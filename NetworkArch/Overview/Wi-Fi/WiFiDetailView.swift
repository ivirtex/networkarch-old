//
//  WiFiDetailView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI
import FGRoute

struct WiFiDetailView: View {
    @State var ssid = FGRoute.getSSID()
    @State var bssid = FGRoute.getBSSID()
    @State var ipv4 = FGRoute.getIPAddress()
    @State var defaultGateway = FGRoute.getGatewayIP()
    @State var connectionStatus = FGRoute.isWifiConnected()
    @State var timer: Timer?
    
    var body: some View {
        List {
            Section(header: WiFiHeader()) {
                if connectionStatus == true {
                    HStack {
                        Text("Status")
                            .font(.subheadline)
                        Spacer()
                        StatusView(backgroundColor: Color.green, text: "Online")
                    }
                }
                else {
                    HStack {
                        Text("Status")
                            .font(.subheadline)
                        Spacer()
                        StatusView(backgroundColor: Color.red, text: "Offline")
                    }
                }
               
                InfoRow(leftSide: "SSID", rightSide: ssid ?? "Not available")
                InfoRow(leftSide: "BSSID", rightSide: bssid ?? "Not available")
                
                if let safeDefaultGateway = defaultGateway {
                    InfoRow(leftSide: "Default Gateway", rightSide: safeDefaultGateway)
                }
                else {
                    InfoRow(leftSide: "Default Gateway", rightSide: "Not available")
                }
                
                if ipv4 != "error" {
                    InfoRow(leftSide: "Internal IP Adress", rightSide: ipv4!)
                }
                else {
                    InfoRow(leftSide: "Internal IP Adress", rightSide: "Not available")
                }
                
                
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: {
            locationManager.requestWhenInUseAuthorization()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                ssid = FGRoute.getSSID()
                bssid = FGRoute.getBSSID()
                ipv4 = FGRoute.getIPAddress()
                defaultGateway = FGRoute.getGatewayIP()
                connectionStatus = FGRoute.isWifiConnected()
            })
        })
    }
}

struct WiFiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WiFiDetailView()
    }
}
