//
//  NetworkArchApp.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI
import GoogleMobileAds

@main
struct NetworkArchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                }
        }
    }
}
