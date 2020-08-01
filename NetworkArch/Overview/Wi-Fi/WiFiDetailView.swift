//
//  WiFiDetailView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI
import IP

let wifiDetail = WiFiInformation()
let interfaces = try! Interface.all()
let interface = interfaces[0]
let message = try! System.retrieveDefaultGatewayMessage(from: interface)

struct WiFiDetailView: View {
    @State var ipv4 = try! Host.current().ipv4s
    @State var ssid = wifiDetail.getWiFiInfo()?.networkName
    @State var bssid = wifiDetail.getWiFiInfo()?.macAddress
    @State var timer: Timer?
    
    var body: some View {
        List {
            Section(header: WiFiHeader()) {
                InfoRow(leftSide: "SSID", rightSide: ssid ?? "Not available")
                InfoRow(leftSide: "BSSID", rightSide: bssid ?? "Not available")
                
                if let safeIPv4 = ipv4 {
                    InfoRow(leftSide: "Internal IP Address", rightSide: safeIPv4[0].address)
                }
                else {
                    InfoRow(leftSide: "Internal IP Address", rightSide: "Not available")
                }
                
                if let safeMessage = message {
                    InfoRow(leftSide: "Default Gateway", rightSide: String(describing: safeMessage.gateway))
                }
                else {
                    InfoRow(leftSide: "Default Gateway", rightSide: "Not available")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: {
            locationManager.requestWhenInUseAuthorization()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                ssid = wifi.getWiFiInfo()?.networkName
                bssid = wifi.getWiFiInfo()?.macAddress
                ipv4 = try! Host.current().ipv4s
            })
        })
    }
}

struct WiFiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WiFiDetailView()
    }
}
