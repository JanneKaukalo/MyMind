//
//  FeedsData.swift
//  MyMind
//
//  Created by Janne Jussila on 13.2.2022.
//

import Foundation
import Combine

class FeedsData: ObservableObject {
    
    typealias Feed = FeedsModel.Feed
    typealias Channel = FeedsModel.Channel
    
    enum FeedGategory: String, CaseIterable, Identifiable {
        case following, popular, explore
        var id: String { rawValue }
    }
    
    @Published private var followingChannels: [Channel]!
    private var model = FeedsModel()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
        
    
    private var cancellable: AnyCancellable?
    @Published private var feedsUpdated = false
    
    init() {
        setFollowingChannel()
        cancellable = model.$feeds
            .receive(on: RunLoop.main)
            .sink() { _ in self.feedsUpdated.toggle() }
    }
    
    // MARK: - API
    // bit wacky way, but I need to be able to tell from model if some feeds area available
    var feedsReady: Bool {
        get { model.atLeastSomeFeedsAreAvailable }
        set { }
    }

    
    var gategories: [FeedGategory] {
        FeedGategory.allCases
    }
    
    func channels(for gategory: FeedGategory) -> [Channel] {
        switch gategory {
        case .following:
            return followingChannels
        case .popular:
            return model.popularChannels
        case .explore:
            return model.allChannels
        }
    }
    
    func isFollowing(_ channel: Channel) -> Bool {
        followingChannels.contains(channel)
    }
    
    func followers(for channel: Channel) -> String {
        let number = model.followers(for: channel)
        return channelFollowers(for: number)
    }
    
    func feeds(for channel: Channel) -> [Feed] {
        model.feeds(for: channel)
            .sorted( by: { $0.itemPubDate > $1.itemPubDate} )
    }
    
    func toggle(_ channel: Channel) {
        if followingChannels.contains(channel) {
            guard let index = followingChannels.firstIndex(of: channel) else { return }
            followingChannels.remove(at: index)
        } else {
            followingChannels.append(channel)
        }
        guard let data = try? encoder.encode(followingChannels) else { return }
        UserDefaults.standard.set(data, forKey: FeedGategory.following.rawValue)
    }

    
    // MARK: - private methods
    private func setFollowingChannel() {
        guard let data = UserDefaults.standard.data(forKey: FeedGategory.following.rawValue) else {
            followingChannels = []; return }
        let following = try? decoder.decode(Array<Channel>.self, from: data)
        followingChannels = following ?? []
    }
    
    private func channelFollowers(for number: Int) -> String {
        let suffix = ["", "K", "M"]
        var index = 0
        var value = Double(number)
        while((value / 1000) >= 1) && index < 2 {
            value /= 1000
            index += 1
        }
        // ok, in design wanted to get in full values etc. would probably make more sense to have one decimal
        // -> "%.1f%@"
        return String(format: "%.0f%@", value, suffix[index])
    }
    
}

