//
//  OverviewTab.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI
import CoreLocation
import FGRoute

let locationManager = CLLocationManager()
let carrier = CellularData()

struct OverviewTab: View {
    @State var ipv4 = FGRoute.getIPAddress()
    @State var ssid = FGRoute.getSSID()
    @State var carrierInfo = carrier.carrierDetail
    @State var carrierRadioTechnologyRaw = carrier.carrierTechnology
    @State var timer: Timer?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: WiFiHeader()) {
                    if let safeSSID = ssid, let safeIPv4 = ipv4 {
                        WiFiSection(ssid: String(describing: safeSSID), wifiImage: "wifi", ipAddress: safeIPv4)
                    }
                    else {
                        WiFiSection(ssid: "SSID not available", wifiImage: "wifi.slash", ipAddress: "N/A")
                    }
                }
                
                Section(header: CellularHeader()) {
                    if let safeCarrierInfo = carrierInfo, let safeCarrierRadio = carrierRadioTechnologyRaw {
                        CellularSection(carrier: String(describing: safeCarrierInfo.first?.value.carrierName ?? "Not available"), cellularImage: "antenna.radiowaves.left.and.right", radioTechnology: CellularRadioConstants.radioTechnology[safeCarrierRadio.first?.value ?? "N/A"] ?? "N/A")
                    }
                    else {
                        CellularSection(carrier: "Carrier not available", cellularImage: "antenna.radiowaves.left.and.right", radioTechnology: "Not available")
                    }
                }
                
                Section(header: ToolsHeader()) {
                    NavigationLink(destination: PingView(searchBarIP: "")) {
                        Text("Ping")
                    }
                    NavigationLink(destination: ScannerView()) {
                        Text("LAN Scan")
                    }
                    NavigationLink(destination: WoLView()) {
                        Text("Wake on LAN")
                    }
                    NavigationLink(destination: TracerouteView()) {
                        Text("Visual Traceroute")
                    }
                    NavigationLink(destination: DNSLookupView()) {
                        Text("DNS Lookup")
                    }
                    NavigationLink(destination: SpeedTestView()) {
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
                ssid = FGRoute.getSSID()
                ipv4 = FGRoute.getIPAddress()
                carrierInfo = carrier.carrierDetail
                carrierRadioTechnologyRaw = carrier.carrierTechnology
            })
        })
    }
}

struct OverviewTab_Previews: PreviewProvider {
    static var previews: some View {
        OverviewTab()
    }
}

struct WiFiHeader: View {
    var body: some View {
        Text("Wi-Fi")
    }
}

struct CellularHeader: View {
    var body: some View {
        Text("Cellular Network")
    }
}

struct ToolsHeader: View {
    var body: some View {
        Text("Tools")
    }
}
