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
    
    func deleteHTML(tag:String) -> String {
        replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }

    func deleteHTML(tags:[String]) -> String {
        var mutableString = self
        tags.forEach {
            mutableString = mutableString.deleteHTML(tag: $0)
        }
        return mutableString
    }
    
}
