//
//  OverviewTab.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI
import CoreLocation
import FGRoute
import GoogleMobileAds

let locationManager = CLLocationManager()
let carrier = CellularData()

struct OverviewTab: View {
    @AppStorage("Whois unlock") var isWhoisUnlocked = false
    @AppStorage("DNS unlock") var isDNSUnlocked = false
    @AppStorage("Ads remove") var areAdsRemoved = false
    @AppStorage("Whois ads watched") var whoisAdWatchedTimes = 0
    @AppStorage("DNS ads watched") var DNSadWatchedTimes = 0
    @State private var ipv4 = FGRoute.getIPAddress()
    @State private var ssid = FGRoute.getSSID()
    @State var isWhoisPresented = false
    @State var isDNSPresented = false
    @State private var carrierInfo = carrier.carrierDetail
    @State private var cellularIP = UIDevice.current.ipv4(for: .cellular)
    @State private var timer: Timer?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Wi-Fi")) {
                    if let safeSSID = ssid, let safeIPv4 = ipv4 {
                        WiFiSection(ssid: String(describing: safeSSID), wifiImage: "wifi", ipAddress: safeIPv4)
                    }
                    else {
                        WiFiSection(ssid: "SSID not available", wifiImage: "wifi.slash", ipAddress: "N/A")
                    }
                }
                
                Section(header: Text("Cellular Network")) {
                    if let safeCarrierInfo = carrierInfo {
                        if let safeCarrierIP = cellularIP {
                            CellularSection(carrier: safeCarrierInfo.first?.value.carrierName ?? "Carrier not available", cellularImage: "antenna.radiowaves.left.and.right", ipAddress: safeCarrierIP)
                        }
                        else {
                            CellularSection(carrier: safeCarrierInfo.first?.value.carrierName ?? "Carrier not available", cellularImage: "antenna.radiowaves.left.and.right", ipAddress: "N/A")
                        }
                    }
                    else {
                        CellularSection(carrier: "Carrier not available", cellularImage: "antenna.radiowaves.left.and.right", ipAddress: "N/A")
                    }
                }
                
                if !areAdsRemoved {
                    Section {
                        HStack {
                            Banner()
                        }
                    }
                }
                
                Section(header: Text("Utilities")) {
                    NavigationLink(destination: PingView()) {
                        Text("Ping")
                    }
                    
                    NavigationLink(destination: WoLView()) {
                        Text("Wake on LAN")
                    }
                    
                    if isWhoisUnlocked || whoisAdWatchedTimes == 1 {
                        NavigationLink(destination: WhoisView()) {
                            Text("Whois")
                        }
                    }
                    else {
                        NavigationLink(destination: WhoisModalBuyView()) {
                            Text("Whois")
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    
                    if isDNSUnlocked || DNSadWatchedTimes == 1 {
                        NavigationLink(destination: DNSLookupView()) {
                            Text("DNS Lookup")
                        }
                    }
                    else {
                        NavigationLink(destination: DNSModalBuyView()) {
                            Text("DNS Lookup")
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    
                    //                    NavigationLink(destination: ScannerView()) {
                    //                        Text("LAN Scan")
                    //                    }
                    //                    NavigationLink(destination: TracerouteView()) {
                    //                        Text("Visual Traceroute")
                    //                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Overview")
        }
        .onAppear(perform: {
            locationManager.requestWhenInUseAuthorization()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                ssid = FGRoute.getSSID()
                ipv4 = FGRoute.getIPAddress()
                carrierInfo = carrier.carrierDetail
                cellularIP = UIDevice.current.ipv4(for: .cellular)
            })
        })
    }
}

struct OverviewTab_Previews: PreviewProvider {
    static var previews: some View {
        OverviewTab()
    }
}
