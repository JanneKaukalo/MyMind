//
//  FeedsModel.swift
//  MyMind
//
//  Created by Janne Jussila on 14.2.2022.
//

import Foundation


struct FeedsModel {
    
    struct Feed: Identifiable {
        let channelTitle: String
        let channelLink: String
        let itemDate: Date
        let itemTitle: String
        let itemDescription: String
        let itemLink: String
        var id: String { itemLink }
        
    }
    
    enum Channel: String, CustomStringConvertible {
        case fashion, science, auto, technology, entertainment, environment, finances, travel
        var description: String { rawValue }
    }
    
}
