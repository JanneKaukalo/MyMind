//
//  MyMindApp.swift
//  MyMind
//
//  Created by Janne Jussila on 12.2.2022.
//

import SwiftUI

@main
struct MyMindApp: App {
    
    init() {
        MyMindSettings.navBarSettings()
    }
    
    var body: some Scene {
        WindowGroup {
            LandingPage(data: FeedsData(feedsService: Feeds()))
        }
    }
    
    
}
