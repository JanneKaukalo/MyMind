//
//  Extension + Font.swift
//  MyMind
//
//  Created by Janne Jussila on 12.2.2022.
//

import SwiftUI

extension Font {
    static let myMindTitleThumbnail = Font.custom("Helvetica Neue", fixedSize: 12)
        .uppercaseSmallCaps()
    static let myMindTitleChannel = Font.custom("Helvetica Neue", fixedSize: 20)
        .uppercaseSmallCaps()
        .bold()
    static let myMindTitleCategory = Font.custom("Helvetica Neue", fixedSize: 12)
    static let myMindBody = Font.custom("Helvetica Neue", fixedSize: 14)
    static let myMindBodyBold = myMindBody.bold()
    static let myMindDescription = Font.custom("Helvetica Neue", fixedSize: 12)
}

