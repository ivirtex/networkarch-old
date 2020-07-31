//
//  ContentView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            OverviewTab().tabItem {
                Image(systemName: "house")
                Text("Overview")
            }
            
            SettingsTab().tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
