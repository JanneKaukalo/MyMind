//
//  ChannelSelectionView.swift
//  MyMind
//
//  Created by Janne Jussila on 12.2.2022.
//

import SwiftUI

struct ChannelSelectionView: View {
    
    @EnvironmentObject var data: FeedsData
    @State private var feedsSelection: FeedsData.FeedGategory = .following
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("bg")
                        .resizable()
                        .ignoresSafeArea()
                    VStack(alignment: .center, spacing: 0) {
                        gategorySelections(for: geometry.size.width)
                            .padding(Constants.selectionPadding)
                        channels
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("navbar_logo")
                    }
                }
            }
        }
    }
    
    private func gategorySelections(for width: CGFloat) -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(data.gategories) { gategory in
                Text(gategory.rawValue.firstUppercased)
                    .font(feedsSelection != gategory ? .myMindTitleThumbnail : .myMindTitleThumbnail.bold())
                // really bad way to get even frame for all... but enough for now
                    .frame(width: width / Constants.gategoryWidthDivider, height: width / Constants.gategoryHeightDivider)
                    .overlay {
                        RoundedRectangle(cornerRadius: width / Constants.gategoryHeightDivider / 2)
                            .stroke(lineWidth: Constants.selectedGategoryLineWidth)
                            .foregroundColor(.myMindPink)
                            .opacity(feedsSelection != gategory ? 0 : 1)
                    }
                    .onTapGesture {
                        withAnimation {
                            feedsSelection = gategory
                        }
                    }
                if gategory != data.gategories.last {
                    Spacer()
                }
            }
        }
        .font(.myMindTitleCategory)
        .foregroundColor(.myMindWhite)
    }
    
    private var channels: some View {
        ScrollView {
            LazyVGrid(columns: gridItems(), alignment: .center, spacing: 0) {
                ForEach(data.channels(for: feedsSelection)) { channel in
                    NavigationLink(destination: ChannelView(channel: channel)) {
                        ZStack {
                            Image("channel_\(channel)")
                                .resizable()
                                .aspectRatio(1,contentMode: .fit)
                            VStack {
                                Spacer()
                                HStack {
                                    Text("\(channel)".uppercased())
                                        .font(.myMindTitleThumbnail)
                                        .foregroundColor(.myMindWhite)
                                        .padding()
                                    Spacer()
                                }
                            }
                        }
                    }
                    .navigationTitle(Text(""))
                }
            }
        }
    }
    
    private func gridItems() -> [GridItem] {
        var gridItem = GridItem()
        gridItem.spacing = 0
        return [gridItem, gridItem]
    }
    
    private struct Constants {
        static let selectionPadding: CGFloat = 20
        static let gategoryWidthDivider: CGFloat = 4
        static let gategoryHeightDivider: CGFloat = gategoryWidthDivider * 3
        static let selectedGategoryLineWidth: CGFloat = 1
    }
}

struct ChannelSelectionView_Previews: PreviewProvider {
    
    struct ChannelSelectionWrapper: View {
        @StateObject var data = FeedsData()
        var body: some View {
            ChannelSelectionView()
                .environmentObject(data)
        }
    }
    
    static var previews: some View {
        ChannelSelectionWrapper()
    }
}
