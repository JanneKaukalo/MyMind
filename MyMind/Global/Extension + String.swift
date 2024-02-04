//
//  Extension + String.swift
//  MyMind
//
//  Created by Janne Jussila on 15.2.2022.
//

import Foundation


extension String {
    var firstUppercased: String {
        guard !isEmpty else { return "" }
        let first = first!.uppercased()
        return first + dropFirst()
    }
        
}
