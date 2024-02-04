//
//  Feed.swift
//  MyMind
//
//  Created by Janne Jussila on 4.2.2024.
//

import Foundation

struct FeedItem: Identifiable, Hashable {
    
    let title: String
    let link: String
    let author: String?
    let pubDate: Date
    let guid: String?
    
    var id: String { guid ?? link }
    
    // MARK: - Hashable
    // just want to use id as hash value even
    // Feed actually would be automatically hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
