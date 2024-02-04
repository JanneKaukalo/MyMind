//
//  FeedService.swift
//  MyMind
//
//  Created by Janne Jussila on 4.2.2024.
//

import Foundation
import Combine

protocol FeedsService {
   
    var popularChannels: [Channel] { get }
    var allChannels: [Channel] { get }
    var feedsUpdated: AnyPublisher<Void, Never> { get }
    
    func followers(for channel: Channel) async -> Int
    func feeds(for channel: Channel) async -> Set<FeedItem>
    
}
