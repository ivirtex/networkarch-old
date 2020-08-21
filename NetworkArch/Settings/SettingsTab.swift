//
//  SettingsTab.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI

struct SettingsTab: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button("Restore Purchases") {
                        //
                    }
                }
                
                Section(header: Text("Purchases")) {
                    Button("Remove Ads") {
                        //
                    }
                    
                    Button("Unlock Whois") {
                        //
                    }
                    
                    Button("Unlock DNS Lookup") {
                        //
                    }
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsTab_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTab()
    }
}
