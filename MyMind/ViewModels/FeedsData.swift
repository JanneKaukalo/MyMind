//
//  FeedsData.swift
//  MyMind
//
//  Created by Janne Jussila on 13.2.2022.
//

import Foundation
import Combine

class FeedsData: ObservableObject {
    
    @Published private var followingChannels: [Channel]!
    @Published private var feedsUpdated = false
    
    private let feedsService: FeedsService
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
    private var cancellable: AnyCancellable?
    private var feedsAvailable = false
    
    init(feedsService: FeedsService) {
        self.feedsService = feedsService
        setFollowingChannel()
        cancellable = feedsService.feedsUpdated
            .receive(on: RunLoop.main)
            .sink() { _ in
                self.feedsUpdated.toggle()
                self.feedsAvailable = true
            }
    }
    
    // MARK: - API
    // bit wacky way, but I need to be able to tell from model if some feeds area available
    // this is used by landingPage as Binding --> { get set }
    var feedsReady: Bool {
        get { feedsAvailable }
        set { }
    }

    var categories: [Category] { Category.allCases }
    
    func channels(for category: Category) -> [Channel] {
        switch category {
        case .following:
            return followingChannels
        case .popular:
            return feedsService.popularChannels
        case .explore:
            return feedsService.allChannels
        }
    }
    
    func isFollowing(_ channel: Channel) -> Bool {
        followingChannels.contains(channel)
    }
    
    func followers(for channel: Channel) async -> String {
        let number = await feedsService.followers(for: channel)
        return channelFollowers(for: number)
    }
    
    func feeds(for channel: Channel) async -> [FeedItem] {
        await feedsService.feeds(for: channel)
            .sorted( by: { $0.pubDate > $1.pubDate} )
    }
    
    func toggle(_ channel: Channel) {
        if followingChannels.contains(channel) {
            guard let index = followingChannels.firstIndex(of: channel) else { return }
            followingChannels.remove(at: index)
        } else {
            followingChannels.append(channel)
        }
        guard let data = try? encoder.encode(followingChannels) else { return }
        UserDefaults.standard.set(data, forKey: Category.following.rawValue)
    }

    
    // MARK: - private methods
    private func setFollowingChannel() {
        guard let data = UserDefaults.standard.data(forKey: Category.following.rawValue) else {
            followingChannels = []; return }
        let following = try? decoder.decode(Array<Channel>.self, from: data)
        followingChannels = following ?? []
    }
    
    private func channelFollowers(for number: Int) -> String {
        let suffix = ["", "K", "M"]
        var index = 0
        var value = Double(number)
        while ((value / 1000) >= 1) && index < 2 {
            value /= 1000
            index += 1
        }
        // ok, in design requirements should show only full values -> "%.0f%@"
        // however one decimal makes more sense when more than 1_000 subs
        let valueFormat = index == 0 ? "%.0f%@" : "%.1f%@"
        return String(format: valueFormat, value, suffix[index])
    }
    
}


