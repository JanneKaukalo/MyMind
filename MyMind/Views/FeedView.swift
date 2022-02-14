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
    @State private var webViewHasFinishedLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                WebView(url: url, doneLoading: $webViewHasFinishedLoading)
                    .navigationBarTitle("\(channel.description) channel".uppercased())
                    .navigationBarTitleDisplayMode(.inline)
                if !webViewHasFinishedLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .myMindDarkBlue))
                        .scaleEffect(1.5)
                }
            }
        }
    }
}

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(channel: .science, url: URL(string: "https://www.equineiq.io")!)
    }
}
