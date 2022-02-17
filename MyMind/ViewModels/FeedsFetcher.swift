//
//  FeedsFetcher.swift
//  MyMind
//
//  Created by Janne Jussila on 15.2.2022.
//

import Foundation
import Network


class FeedsFetcher: NSObject, XMLParserDelegate {
    
    typealias Feed = FeedsModel.Feed
    
    enum FeedsFetcherError: Error {
        case badURLString
        case badNetwork
    }
    
    // MARK: - Singleton
    static let shared = FeedsFetcher()
    
    // just an old habit not to start network calls if network is bad.
    private let nwPathMonitor = NWPathMonitor()
    
    override private init() {
        super.init()
        nwPathMonitor.start(queue: DispatchQueue(label: "com.kaukalo.mymind.FeedsFetcher"))
    }
    
    deinit {
        nwPathMonitor.cancel()
    }
    
    // MARK: - API
    func getFeeds(from url: String) async throws -> Set<Feed> {
        guard nwPathMonitor.currentPath.status == .satisfied else { throw FeedsFetcherError.badNetwork }
        guard let feedURL = URL(string: url) else { throw FeedsFetcherError.badURLString }
        let (data, _) = try await URLSession.shared.data(from: feedURL)
        let parser = FeedsParser(data)
        return Set().union(parser.getFeeds())
    }
}



