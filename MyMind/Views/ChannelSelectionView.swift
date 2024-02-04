//
//  ChannelSelectionView.swift
//  MyMind
//
//  Created by Janne Jussila on 12.2.2022.
//

import SwiftUI

struct ChannelSelectionView: View {
    
    @EnvironmentObject var data: FeedsData
    @State private var feedsSelection: Category = .following
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("bg")
                        .resizable()
                        .ignoresSafeArea()
                    VStack(alignment: .center, spacing: 0) {
                        categorySelections(for: geometry.size.width)
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
    
    private func categorySelections(for width: CGFloat) -> some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(data.categories) { category in
                Text(category.rawValue.firstUppercased)
                    .font(feedsSelection != category ? .myMindTitleThumbnail : .myMindTitleThumbnail.bold())
                // really bad way to get even frame for all... but enough for now
                    .frame(width: width / Constants.categoryWidthDivider, height: width / Constants.categoryHeightDivider)
                    .overlay {
                        RoundedRectangle(cornerRadius: width / Constants.categoryHeightDivider / 2)
                            .stroke(lineWidth: Constants.selectedCategoryLineWidth)
                            .foregroundColor(.myMindPink)
                            .opacity(feedsSelection != category ? 0 : 1)
                    }
                    .onTapGesture {
                        withAnimation {
                            feedsSelection = category
                        }
                    }
                if category != data.categories.last {
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
        static let categoryWidthDivider: CGFloat = 4
        static let categoryHeightDivider: CGFloat = categoryWidthDivider * 3
        static let selectedCategoryLineWidth: CGFloat = 1
    }
}

struct ChannelSelectionView_Previews: PreviewProvider {
    
    struct ChannelSelectionWrapper: View {
        @StateObject var data = FeedsData(feedsService: Feeds())
        var body: some View {
            ChannelSelectionView()
                .environmentObject(data)
        }
    }
    
    static var previews: some View {
        ChannelSelectionWrapper()
    }
}
