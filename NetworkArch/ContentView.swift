//
//  ContentView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("Launch times") static var launchTimes = 0
    @State var isPresented: Bool = false

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
        .sheet(isPresented: $isPresented) {
            IntroductionView(isPresented: $isPresented)
        }
        .onAppear {
            if ContentView.launchTimes == 0 {
                isPresented = true
            }
            else {
                isPresented = false
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
