//
//  ContentView.swift
//  MyMind
//
//  Created by Janne Jussila on 12.2.2022.
//

import SwiftUI

struct LandingPage: View {
    
    @StateObject var data: FeedsData
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                Image("splash_logo")
                    .position(x: geometry.size.width / 2,
                              y: geometry.size.height / 3)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .myMindWhite))
                    .scaleEffect(1.5)
                    .position(x: geometry.size.width / 2,
                              y: geometry.size.height * 2 / 3)
                   
            }
        }
        .fullScreenCover(isPresented: $data.feedsReady) {
            ChannelSelectionView()
        }
        .environmentObject(data)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    struct LandingPageWrapper: View {
        let data = FeedsData(feedsService: Feeds())
        var body: some View {
            LandingPage(data: data)
        }
    }
    
    static var previews: some View {
        LandingPageWrapper()
    }
}
