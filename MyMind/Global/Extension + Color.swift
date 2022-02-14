//
//  Extension + Color.swift
//  MyMind
//
//  Created by Janne Jussila on 12.2.2022.
//

import SwiftUI


extension Color {
   
    init(red: UInt, green: UInt, blue: UInt) {
        self.init(red: Double(red) / 255.0,
                  green: Double(green) / 255.0,
                  blue: Double(blue) / 255.0)
    }
    
    static let myMindPurple = Color(red: UInt(161), green: UInt(117), blue: UInt(211))
    static let myMindPink = Color(red: 230, green: 82, blue: 138)
    static let myMindBlack = Color(red: 29, green: 29, blue: 29)
    static let myMindWhite = Color(red: 255, green: 255, blue: 255)
    static let myMindDarkBlue = Color(red: 19, green: 40, blue: 68)
}
