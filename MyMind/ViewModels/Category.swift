//
//  Category.swift
//  MyMind
//
//  Created by Janne Jussila on 4.2.2024.
//

import Foundation


enum Category: String, CaseIterable, Identifiable {
    case following, popular, explore
    var id: String { rawValue }
}
