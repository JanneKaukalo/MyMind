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
                Text(data.isFollowing(channel) ? "Following" : "Follow")
                    .font(.myMindTitleThumbnail)
                    .fontWeight(data.isFollowing(channel) ? .bold : .regular)
                    .frame(width: width / Constants.gategoryWidthDivider, height: width / Constants.gategoryHeightDivider)
                    .background {
                        Group { // check if there is a better way to do this
                            if data.isFollowing(channel) {
                                RoundedRectangle(cornerRadius: width / Constants.gategoryHeightDivider / 2)
                            } else {
                                RoundedRectangle(cornerRadius: width / Constants.gategoryHeightDivider / 2)
                                    .stroke(lineWidth: Constants.selectedGategoryLineWidth)
                            }
                        }
                        .foregroundColor(.myMindPink)
                    }
                    .onTapGesture {
                        withAnimation {
                            data.toggle(channel)
                        }
                    }
                Text("\(data.followers(for: channel)) Followers")
                    .font(.myMindTitleCategory)
            }
            .foregroundColor(.myMindWhite)
        }
    }
    
    private var feeds: some View {
        List {
            ForEach(data.feeds(for: channel)) { feed in
                VStack(alignment: .leading, spacing: Constants.feedsSpacing) {
                    Text(feed.itemTitle)
                        .font(.myMindBody).bold()
                        .padding(.vertical)
                    HStack(spacing: Constants.feedsChannelSpacing) {
                        Label(feed.channelTitle, image: "icon_list_source")
                        Label(dateFormatter.string(from: feed.itemPubDate), image: "icon_list_time")
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
        static let gategoryWidthDivider: CGFloat = 4
        static let gategoryHeightDivider: CGFloat = gategoryWidthDivider * 3
        static let selectedGategoryLineWidth: CGFloat = 1
        static let feedsSpacing: CGFloat = 3
        static let feedsChannelSpacing: CGFloat = 10
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
