//
//  FeedsParser.swift
//  MyMind
//
//  Created by Janne Jussila on 16.2.2022.
//

import Foundation


// really, really clumsy rss feeds parser...
// if this functionality is needed on real world app
// seriously a Feed structure should be made Decodable
// and modify this to something similar as JSONDecoder....
// ie. FeedsDecoder().decode(Array<Feed>.self, from: data)
class FeedsParser: XMLParser, XMLParserDelegate {
    
    init(_ data: Data) {
        super.init(data: data)
        delegate = self
    }
    
    // MARK: - API
    private var feeds: [FeedsModel.Feed] = []
    
    func getFeeds() -> [FeedsModel.Feed] {
        parse()
        return feeds
    }
    
    
    var xmlDict: [String: String] = [:]
    var channelDict: [String: String] = [:]
    var feedsDict: [[String: String]] = []
    var currentElement = ""
    
    var prefix = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" && channelDict.isEmpty {
            channelDict = xmlDict
            xmlDict = [:]
        }
        if elementName == "channel" {
            prefix = "channel_"
        } else if elementName == "item" {
            prefix = "feed_"
        } else {
            currentElement = elementName
        }
        if elementName == "image" {
            ignoreFoundCharacters = true
        }
    }
    
    var ignoreFoundCharacters = false
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard !ignoreFoundCharacters else { return }
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if xmlDict[prefix + currentElement] == nil {
                xmlDict[prefix + currentElement] = string
            } else {
                xmlDict[prefix + currentElement]!.append(string)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            feedsDict.append(xmlDict)
            xmlDict = [:]
        }
        if elementName == "image" {
            ignoreFoundCharacters = false
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        for feedDict in feedsDict {
            let feed = FeedsModel.Feed(channelTitle: channelDict["channel_title"] ?? "",
                            channelDescription: channelDict["channel_description"] ?? "",
                            channelLink: channelDict["channel_link"] ?? "",
                            itemTitle: feedDict["feed_title"] ?? "",
                            itemLink: feedDict["feed_link"] ?? "",
                            itemPubDate: createDate(from: feedDict["feed_pubDate"]),
                            itemDescription: feedDict["feed_description"] ?? "", // should we take html tags away??
                            itemCreator: feedDict["feed_dc:creator"] ?? "",
                            itemContent: feedDict["feed_content:encoded"] ?? "")
            feeds.append(feed)
        }
        
    }
    
    /// Helper to create Date from given date string. If nil -> returns current date.
    ///
    /// - Note: crashes if value is not in right format
    /// - Parameter value: in format: "Fri, 18 Feb 2022 09:32:52 +0000"
    /// - Returns: Date from value
    private func createDate(from value: String?) -> Date {
        guard let value = value else { return Date() }
        let dateValues = value.components(separatedBy: [" ", ",", ":"])
            .filter { !$0.isEmpty }
        return DateComponents(calendar: Calendar.current,
                                  timeZone: Calendar.current.timeZone,
                                  year: Int(dateValues[3]),
                                  month: Int(dateValues[2]),
                                  day: Int(dateValues[1]),
                                  hour: Int(dateValues[4]),
                                  minute: Int(dateValues[5]),
                                  second: Int(dateValues[6]),
                                  weekday: Int(dateValues[0])).date ?? Date()
    }
    
}
