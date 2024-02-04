//
//  Channel.swift
//  MyMind
//
//  Created by Janne Jussila on 4.2.2024.
//

import Foundation

enum Channel: String, Identifiable, CustomStringConvertible, Codable {
    case fashion, science, auto, technology, entertainment, environment, finances, travel
    var id: String { rawValue }
    var description: String { rawValue }
}
