//
//  OverviewTab.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI
import CoreLocation
import IP

let wifi = WiFiInformation()
let locationManager = CLLocationManager()
let carrier = CellularData()

struct OverviewTab: View {
    @State var ipv4 = try! Host.current().ipv4s
    @State var ssid = wifi.getWiFiInfo()?.networkName
    @State var carrierInfo = carrier.carrierDetail
    @State var timer: Timer?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: WiFiHeader()) {
                    if let safeSSID = ssid, let safeIPv4 = ipv4 {
                        WiFiSection(ssid: String(describing: safeSSID), wifiImage: "wifi", ipAddress: String(describing: safeIPv4[0].address))
                    }
                    else {
                        WiFiSection(ssid: "SSID not available", wifiImage: "wifi.slash", ipAddress: "Not available")
                    }
                }
                
                Section(header: CellularHeader()) {
                    if let safeCarrierInfo = carrierInfo {
                        CellularSection(carrier: String(describing: safeCarrierInfo.first?.value.carrierName ?? "Not available"), cellularImage: "antenna.radiowaves.left.and.right", ipAddress: "0.0.0.0")
                    }
                    else {
                        CellularSection(carrier: "Carrier not available", cellularImage: "antenna.radiowaves.left.and.right", ipAddress: "Not available")
                    }
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
        .onAppear(perform: {
            locationManager.requestWhenInUseAuthorization()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                ssid = wifi.getWiFiInfo()?.networkName
                ipv4 = try! Host.current().ipv4s
                carrierInfo = carrier.carrierDetail
            })
        })
    }
}

struct OverviewTab_Previews: PreviewProvider {
    static var previews: some View {
        OverviewTab()
    }
}
