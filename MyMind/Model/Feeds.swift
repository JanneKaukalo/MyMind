//
//  FeedsModel.swift
//  MyMind
//
//  Created by Janne Jussila on 14.2.2022.
//

import Foundation
import Combine
import FeedKit
import Network

actor Feeds: FeedsService {
    
    private let nwPathMonitor = NWPathMonitor()
    // this should either be a dedicated backend call to get rss feed urls or
    // app needs to have a way to look for available channels
    private let feedURLs: [Channel: [String]]  = [.fashion: ["https://www.elle.com/rss/all.xml/",
                                                             "https://refinery29.com/fashion/rss.xml"],
                                                  .science: ["https://www.newscientist.com/feed/home/?cmpid=RSS%7CNSNS-Home",
                                                             "https://sciencedaily.com/rss"],
                                                  .auto: ["https://paultan.org/feed/",
                                                         "https://feeds.feedburner.com/autonews/BreakingNews"],
                                                  .technology: ["https://mashable.com/feeds/rss/all",
                                                                "https:/wired.com/feed/rss",
                                                                "https://gizmodo.com/rss"],
                                                  .environment: ["https://news.climate.columbia.edu/feed",
                                                                 "https://eponline.com/rss-feeds/energy.aspx?admgarea=RSS",
                                                                 "https://yaleclimateconnections.org/feed"],
                                                  .entertainment: ["https://hollywoodlife.com/feed/",
                                                                   "https://etonline.com/news/rss"],
                                                  .finances: ["https://www.cnbc.com/id/19746125/device/rss/rss.xml",
                                                              "https://www.moneyweb.co.za/feed/"],
                                                  .travel: ["https://handluggageonly.co.uk/feed/",
                                                            "https://phocuswire.com/RSS/All-News"]]
    
    // keeping reference to periodic feed fetching timer
    private var feedFetchingCancellable: AnyCancellable?
    private let _feedsUpdated = PassthroughSubject<Void, Never>()
    nonisolated var feedsUpdated: AnyPublisher<Void, Never> { _feedsUpdated.eraseToAnyPublisher() }
    private var feeds: [Channel: Set<FeedItem>] = [:]

    init() {
        nwPathMonitor.start(queue: DispatchQueue(label: "com.kaukalo.mymind.FeedsFetcher"))
        Task {
            await updateModel()
            await startPeriodicFeedFetching()
        }
    }
    
    deinit {
        nwPathMonitor.cancel()
    }
    
    // MARK: - API
// ok, could return popularChannels randomly... but bit confusing
//    var popularChannels: [Channel] {
//        (0..<(1..<allChannels.count).randomElement()!)
//            .reduce(into: Set<Channel>()) { $0.insert(allChannels[$1]) }
//            .map { $0 }
//    }
   
    // These should come from some dedicated backend, now hardcoded for ui testing
    let popularChannels = [Channel.fashion, .entertainment, .environment, .finances, .travel]

    // same as above
    let allChannels = [Channel.fashion, .science, .auto, .technology,
                               .entertainment, .environment, .finances, .travel]
    
    // OK, this should really come from some backend that knows followers for each channel
    func followers(for channel: Channel) async -> Int {
        (0...5_000_000).randomElement()!
    }
    
    func feeds(for channel: Channel) async -> Set<FeedItem> {
        feeds[channel] ?? []
    }
    
    // MARK: - private functions
    func get(feedsDataFrom url: String) async throws -> Data {
        guard nwPathMonitor.currentPath.status == .satisfied else { throw FeedsError.badNetwork }
        guard let feedURL = URL(string: url) else { throw FeedsError.badURLString }
        let (data, response) = try await URLSession.shared.data(from: feedURL)
        guard let httpURLResponse = response as? HTTPURLResponse,
              (200...299).contains(httpURLResponse.statusCode) else { throw  FeedsError.badResponse }
        return data
    }
    
    private func parse(feedAbstractsFrom data: Data) -> Set<FeedItem> {
        let parser = FeedParser(data: data)
        let result = parser.parse()
        switch result {
        case .success(let feed):
            switch feed {
            case .atom(_):
                fatalError("atom not implemented at the moment")
            case .rss(let rssFeed):
                return Set(rssFeed.asFeedItems)
            case .json(_):
                fatalError("json not implemented at the moment")
            }
        case .failure(let error):
            print("parserError: \(error)")
        }
        return []
    }
    
    private func updateModel() async {
        await withTaskGroup(of: Void.self) { group in
            for topic in feedURLs.keys {
                for feedURL in feedURLs[topic]! {
                    group.addTask {
                        do {
                            let feedData = try await self.get(feedsDataFrom: feedURL)
                            let feeds = await self.parse(feedAbstractsFrom: feedData)
                            await self.update(feedsFrom: feeds, on: topic)
                        } catch {
                            // TODO: this should give some reasonable error to user
                            print("feed fetching issue with: \(error)")
                        }
                    }
                }
            }
        }
        _feedsUpdated.send()
    }
    
    private func update(feedsFrom latestFeeds: Set<FeedItem>, on channel: Channel) {
        if feeds[channel] == nil {
            feeds[channel] = latestFeeds
        } else {
            feeds[channel] = feeds[channel]!.union(latestFeeds)
        }
    }
    
    private func startPeriodicFeedFetching() {
        feedFetchingCancellable = Timer.publish(every: Constants.updateInterval, on: RunLoop.main, in: .default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                Task {
                    // if popularChannels, allChannels and followers from backend -> fetch them
                    await self.updateModel()
                }
            })
    }
    
}

extension Feeds {
    
    struct Constants {
        static let updateInterval: Double = 60
    }
    
    enum FeedsError: Error {
        case badURLString
        case badNetwork
        case badResponse
    }
    
}

extension RSSFeedItem {
    
    var asFeedItem: FeedItem? {
        guard let title, let link, let pubDate else { return nil }
        return FeedItem(title: title,
                        link: link,
                        author: dublinCore?.dcCreator ?? author ?? dublinCore?.dcPublisher ?? dublinCore?.dcContributor,
                        pubDate: pubDate,
                        guid: guid?.value)
    }
}

extension RSSFeed {
    
    var asFeedItems: [FeedItem] {
            guard let items = items else { return [] }
            return items.compactMap { item in
                guard let feedItem = item.asFeedItem else { return nil }
                let author = feedItem.author ?? dublinCore?.dcCreator ?? dublinCore?.dcPublisher ?? dublinCore?.dcContributor ?? title
                return FeedItem(
                    title: feedItem.title,
                    link: feedItem.link,
                    author: author,
                    pubDate: feedItem.pubDate,
                    guid:  feedItem.guid)
            }
        }
    
}



