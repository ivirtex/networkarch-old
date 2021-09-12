//
//  OverviewTab.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import CoreLocation
import FGRoute
import SwiftUI

let locationManager = CLLocationManager()
let carrier = CellularData()

struct OverviewTab: View {
    @AppStorage("Whois unlock") var isWhoisUnlocked = false
    @AppStorage("DNS unlock") var isDNSUnlocked = false
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
                    } else {
                        WiFiSection(ssid: "SSID not available", wifiImage: "wifi.slash", ipAddress: "N/A")
                    }
                }

                Section(header: Text("Cellular Network")) {
                    if let safeCarrierInfo = carrierInfo {
                        if let safeCarrierIP = cellularIP {
                            CellularSection(carrier: safeCarrierInfo.first?.value.carrierName ?? "Carrier not available", cellularImage: "antenna.radiowaves.left.and.right", ipAddress: safeCarrierIP)
                        } else {
                            CellularSection(carrier: safeCarrierInfo.first?.value.carrierName ?? "Carrier not available", cellularImage: "antenna.radiowaves.left.and.right", ipAddress: "N/A")
                        }
                    } else {
                        CellularSection(carrier: "Carrier not available", cellularImage: "antenna.radiowaves.left.and.right", ipAddress: "N/A")
                    }
                }

                Section(header: Text("Utilities")) {
                    NavigationLink(destination: PingView()) {
                        Text("Ping")
                    }

                    NavigationLink(destination: WoLView()) {
                        Text("Wake on LAN")
                    }

                    if isWhoisUnlocked {
                        NavigationLink(destination: WhoisView()) {
                            Text("Whois")
                        }
                    } else {
                        Button("Whois") {
                            self.isWhoisPresented = true
                        }
                        .sheet(isPresented: $isWhoisPresented) {
                            WhoisModalBuyView(isPresented: $isWhoisPresented)
                        }
                    }

                    if isDNSUnlocked {
                        NavigationLink(destination: DNSLookupView()) {
                            Text("DNS Lookup")
                        }
                    } else {
                        Button("DNS Lookup") {
                            self.isDNSPresented = true
                        }
                        .sheet(isPresented: $isDNSPresented) {
                            DNSModalBuyView(isPresented: $isDNSPresented)
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
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
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
