//
//  OverviewTab.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI

struct OverviewTab: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: WiFiHeader()) {
                    WiFiSection(ssid: "SSID", wifiImage: "wifi", ipAddress: "0.0.0.0")
                }
                
                Section(header: CellularHeader()) {
                    CellularSection(brand: "Brand", cellularImage: "antenna.radiowaves.left.and.right", ipAddress: "0.0.0.0")
                }
                
                Section(header: ToolsHeader()) {
                    NavigationLink(destination: ToolsView()) {
                        Text("LAN Scan")
                    }
                    NavigationLink(destination: ToolsView()) {
                        Text("Wake on LAN")
                    }
                    NavigationLink(destination: ToolsView()) {
                        Text("Visual Traceroute")
                    }
                    NavigationLink(destination: ToolsView()) {
                        Text("DNS Lookup")
                    }
                    NavigationLink(destination: ToolsView()) {
                        Text("Speed Test")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Overview")
        }
    }
}

struct OverviewTab_Previews: PreviewProvider {
    static var previews: some View {
        OverviewTab()
    }
}
