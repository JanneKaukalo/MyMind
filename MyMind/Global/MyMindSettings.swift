//
//  MyMindSettings.swift
//  MyMind
//
//  Created by Janne Jussila on 12.2.2022.
//

import UIKit

struct MyMindSettings {
    
    static func navBarSettings() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(.myMindPurple)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(.myMindWhite),
                                          .font: UIFont(name: "HelveticaNeue-Bold",
                                                        size: 20)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.myMindWhite),
                                               .font: UIFont(name: "HelveticaNeue-Bold",
                                                             size: 30)!]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UIBarButtonItem.appearance().tintColor = UIColor(.myMindWhite)
    }
    
    
    
}
