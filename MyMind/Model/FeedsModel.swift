//
//  FeedsModel.swift
//  MyMind
//
//  Created by Janne Jussila on 14.2.2022.
//

import Foundation
import Combine

class FeedsModel {
    
    
    // MARK: - Feed
    struct Feed: Identifiable, Hashable {
        let channelTitle: String
        let channelDescription: String
        let channelLink: String
        let itemTitle: String
        let itemLink: String
        let itemPubDate: Date
        let itemDescription: String
        let itemCreator: String
        let itemContent: String
       
        var id: String { itemLink }
        
        // MARK: - Hashable
        // just want to use id as hash value even
        // even Feed actually would be automatically hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
    }
    
    enum Channel: String, Identifiable, CustomStringConvertible, Codable {
        case fashion, science, auto, technology, entertainment, environment, finances, travel
        var id: String { rawValue }
        var description: String { rawValue }
    }
    
    private let feedsFetcher = FeedsFetcher.shared
    // this should either be a dedicated backend call to get rss feed urls or
    // app needs to have a way to look for channels have them stored
    private var feedURLs: [Channel: [String]]  = [.fashion: ["https://www.elle.com/rss/all.xml/"],
                                                  .science: ["https://www.newscientist.com/feed/home/?cmpid=RSS%7CNSNS-Home"],
                                                  .auto: ["https://paultan.org/feed/"],
                                                  .technology: ["https://techcrunch.com/feed/",
                                                                "https://www.technologyreview.com/topnews.rss"],
                                                  .environment: ["https://inhabitat.com/environment/feed/"],
                                                  .entertainment: ["https://hollywoodlife.com/feed/"],
                                                  .finances: ["https://www.cnbc.com/id/19746125/device/rss/rss.xml",
                                                              "https://www.moneyweb.co.za/feed/"],
                                                  .travel: ["https://handluggageonly.co.uk/feed/"]]
    
    // keeping reference to periodic feed fetching timer
    private var feedFetchingTimer: Timer!
    @Published private(set) var feeds: [Channel: Set<Feed>] = [:]
    
    // ok, bit explanation here... we are periodically fetching feeds async manner. It's quite possible
    // that reading feeds and writing feeds can happen simultaneously
    // thus making reading and writing to happen on this queue and managing writing to be w/ .barrier flag
    // there is no race condition ever.
    private let feedsQueue = DispatchQueue(label: "com.kaukalo.myMind.FeedsModel.feedsQueue",
                                           qos: .userInitiated,
                                           attributes: .concurrent,
                                           autoreleaseFrequency: .inherit,
                                           target: nil)
    
    init() {
        updateModel()
        startPeriodicFeedFetching()
    }
    
    // MARK: - API
    // These should come from some dedicated backend, now hardcoded for ui testing
    private(set) var popularChannels = [Channel.fashion, .entertainment,
                                   .environment, .finances, .travel]
    
    // ok, could return popularChannels randomly... but bit confusing
//    var popularChannels: [Channel] {
//        (0..<(1..<allChannels.count).randomElement()!)
//            .reduce(into: Set<Channel>()) { $0.insert(allChannels[$1]) }
//            .map { $0 }
//    }
    
    // same as above
    private(set) var allChannels = [Channel.fashion, .science, .auto, .technology,
                               .entertainment, .environment, .finances, .travel]
    
    // OK, this should really come from some backend that knows followers for each channel
    func followers(for channel: Channel) -> Int {
        (0...5_000_000).randomElement()!
    }
    
    func feeds(for channel: Channel) -> Set<Feed> {
        // so, using our queue to read
        feedsQueue.sync {
            feeds[channel] ?? []
        }
    }
    
    var atLeastSomeFeedsAreAvailable: Bool { !feeds.isEmpty }
    
    // MARK: - private functions
    private func updateModel() {
        for topic in feedURLs.keys {
            for feedUrl in feedURLs[topic]! {
                Task(priority: .userInitiated) {
                    do {
                        let feedsForUrl = try await feedsFetcher.getFeeds(from: feedUrl)
                        // this is the real trick... we write feeds so that it's quaranteed
                        // that no other writes or reads are happening at the same time...
                        feedsQueue.async(flags: .barrier) { [weak self] in
                            if self?.feeds[topic] == nil {
                                self?.feeds[topic] = feedsForUrl
                            } else {
                                self?.feeds[topic] = self?.feeds[topic]!.union(feedsForUrl)
                            }
                        }
                    } catch {
                        // not implemented, should alert user about errors
                        print("\(error)")
                    }
                }
            }
        }
    }
    
    private func startPeriodicFeedFetching() {
        feedFetchingTimer = Timer.scheduledTimer(withTimeInterval: 60,
                                                 repeats: true) { [weak self] _ in
            self?.updateModel()
        }
    }
    

}



