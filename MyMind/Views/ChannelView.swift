//
//  ChannelView.swift
//  MyMind
//
//  Created by Janne Jussila on 13.2.2022.
//

import SwiftUI

struct ChannelView: View {
    
    @EnvironmentObject var data: FeedsData
    @State private var selectedFeed: FeedsData.Feed?
    var channel: FeedsData.Channel
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                channelDescription(for: geometry.size.width)
                feeds
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("navbar_logo")
            }
        }
    }
    
    private func channelDescription(for width: CGFloat) -> some View {
        ZStack {
            Image(channel.description == "science" ? "bg_channel_\(channel.description)" : "channel_\(channel.description)")
                .resizable()
                .aspectRatio(2, contentMode: .fit)
            VStack {
                Text("\(channel.description) channel".uppercased())
                    .font(.myMindTitleChannel)
                Text(FeedsData.FeedGategory.following.description)
                    .font(.myMindTitleThumbnail).bold()
                    .frame(width: width / Constants.gategoryWidthDivider, height: width / Constants.gategoryHeightDivider)
                    .background {
                        RoundedRectangle(cornerRadius: width / Constants.gategoryHeightDivider / 2)
                            .fill(Color.myMindPink)
                    }
                    .opacity(data.isFollowing(channel) ? 1 : 0)
                Text("\(data.followers(for: channel)) Followers")
                    .font(.myMindTitleCategory)
            }
            .foregroundColor(.myMindWhite)
        }
    }
    
    private var feeds: some View {
        List {
            ForEach(data.feeds(for: channel)) { feed in
                VStack(alignment: .leading, spacing: 3) {
                    Text(feed.itemTitle)
                        .font(.myMindBody).bold()
                        .padding(.vertical)
                    HStack(spacing: 10) {
                        Label(feed.channelTitle, image: "icon_list_source")
                        Label(dateFormatter.string(from: feed.itemDate), image: "icon_list_time")
                    }
                    .font(.myMindDescription)
                }
                .onTapGesture {
                    selectedFeed = feed
                }
                .foregroundColor(.myMindBlack)
            }
        }
        .listStyle(.plain)
        .sheet(item: $selectedFeed) { feed in
            FeedView(channel: channel, url: URL(string: feed.itemLink)!)
        }
    }
    
    private struct Constants {
        static let selectionPadding: CGFloat = 20
        static let gategoryWidthDivider: CGFloat = 4
        static let gategoryHeightDivider: CGFloat = gategoryWidthDivider * 3
        static let selectedGategoryLineWidth: CGFloat = 1
    }
}


struct ChannelView_Previews: PreviewProvider {
    
    struct ChannelViewWrapper: View {
        @StateObject var data = FeedsData()
        var body: some View {
            ChannelView(channel: .science)
                .environmentObject(data)
        }
    }
    
    static var previews: some View {
        ChannelViewWrapper()
    }
}
