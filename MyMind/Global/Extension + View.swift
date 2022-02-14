//
//  Extension + View.swift
//  MyMind
//
//  Created by Janne Jussila on 12.2.2022.
//

import SwiftUI

extension View {
    func myMindTitleThumbnail() -> some View {
        modifier(MyMindTitleThumbnail())
    }
    
    func myMindTitleChannel() -> some View {
        modifier(MyMindTitleChannel())
    }
    
    func myMindTitleCategory() -> some View {
        modifier(MyMindTitleCategory())
    }
    
    func myMindBody() -> some View {
        modifier(MyMindBody())
    }
    
    func myMindBodyBold() -> some View {
        modifier(MyMindBodyBold())
    }
    
    func myMindDescription() -> some View {
        modifier(MyMindDescription())
    }
    
    func myMindBorder() -> some View {
        modifier(MyMindPinkBorder())
    }
}

// MARK: - ViewModifiers
struct MyMindTitleThumbnail: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.myMindTitleThumbnail)
            .foregroundColor(.myMindWhite)
    }
}

struct MyMindTitleChannel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.myMindTitleChannel)
            .foregroundColor(.myMindWhite)
    }
}

struct MyMindTitleCategory: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.myMindTitleCategory)
            .foregroundColor(.myMindWhite)
    }
}

struct MyMindBody: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.myMindBody)
            .foregroundColor(.myMindBlack)
    }
}

struct MyMindBodyBold: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.myMindBodyBold)
            .foregroundColor(.myMindBlack)
    }
}

struct MyMindDescription: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.myMindDescription)
            .foregroundColor(.myMindBlack)
    }
}

struct MyMindPinkBorder: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: geometry.size.height / 2)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.myMindPink)
                }
        }
    }
}


