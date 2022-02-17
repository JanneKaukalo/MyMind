//
//  FeedView.swift
//  MyMind
//
//  Created by Janne Jussila on 14.2.2022.
//

import SwiftUI
import WebKit

struct FeedView: View {
    
    var channel: FeedsData.Channel
    var url: URL
    @State private var showActivityIndicator = true
    
    var body: some View {
        NavigationView {
            ZStack {
                WebView(url: url, showActivityIndicator: $showActivityIndicator)
                if showActivityIndicator {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .myMindDarkBlue))
                        .scaleEffect(1.5)
                }
            }
            .navigationBarTitle("\(channel.description) channel".uppercased())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(channel: .science, url: URL(string: "https://www.equineiq.io")!)
    }
}
