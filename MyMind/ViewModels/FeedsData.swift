//
//  FeedsData.swift
//  MyMind
//
//  Created by Janne Jussila on 13.2.2022.
//

import Foundation


class FeedsData: ObservableObject {
    
    typealias Feed = FeedsModel.Feed
    typealias Channel = FeedsModel.Channel
    
    enum FeedGategory: Int, CaseIterable, Identifiable, CustomStringConvertible, Equatable {
        case following = 0, popular, explore
        
        var id: Int { rawValue }
        var description: String {
            switch self {
            case .following:
                return "Following"
            case .popular:
                return "Popular"
            case .explore:
                return "Explore"
            }
        }
    }
    
    @Published var feeds: [FeedGategory: [Feed]] = [:] // create correct type for feeds
    @Published private(set) var feedsSelection: FeedGategory!
    private(set) var channels: [FeedGategory: [Channel]] = [.following: [.science, .auto, .technology,
                                                                            .environment, .finances],
                                                            .popular: [.fashion, .auto, .entertainment,
                                                                        .environment, .finances, .travel],
                                                            .explore: [.fashion, .science, .auto, .technology,
                                                                        .entertainment, .environment, .finances, .travel]]
    
    private var model = FeedsModel()
    
    init() {
        simulateFeedsDownload()
        setFeedsSelection()
    }
    
    // MARK: - API
    var feedsAreAvailable: Bool {
        get { !feeds.isEmpty }
        set {
            guard !newValue else { return }
            feeds[.explore] = [Feed(channelTitle: "Janne",
                        channelLink: "www.kaukalo.fi",
                        itemDate: Date(),
                        itemTitle: "Kelmi",
                        itemDescription: "hevonen joka jaksaa yllättää",
                        itemLink: "https://www.equineiq.io")]
        }
    }
    
    var gategories: [FeedGategory] {
        FeedGategory.allCases
    }
    
    func didSelect(_ feed: FeedGategory) {
        feedsSelection = feed
    }
    
    func isFollowing(_ channel: Channel) -> Bool {
        channels[.following]?.contains(channel) ?? false
    }
    
    func followers(for channel: Channel) -> String {
        "\((0...500).randomElement()!)K"
    }
    
    func feeds(for channel: Channel) -> [Feed] {
        [Feed(channelTitle: "Janne",
                    channelLink: "www.kaukalo.fi",
                    itemDate: Date(),
                    itemTitle: "Kelmi",
                    itemDescription: "hevonen joka jaksaa yllättää",
                    itemLink: "https://www.equineiq.io")]
    }
    
    // NARK: - private methods
    private func simulateFeedsDownload() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.feeds[.explore] = [Feed(channelTitle: "Janne",
                                         channelLink: "www.kaukalo.fi",
                                         itemDate: Date(),
                                         itemTitle: "Kelmi",
                                         itemDescription: "hevonen joka jaksaa yllättää",
                                         itemLink: "https://www.equineiq.io")]
        }
    }
    
    private func setFeedsSelection() {
        feedsSelection = FeedGategory.allCases.randomElement()
    }
}
