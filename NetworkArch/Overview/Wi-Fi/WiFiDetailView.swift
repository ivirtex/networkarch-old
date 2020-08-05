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
    @State var extIPv4: String? = nil
    @State var timer: Timer?
    
    var body: some View {
        List {
            Section {
                if connectionStatus == true {
                    HStack {
                        Text("Status")
                            .font(.subheadline)
                        Spacer()
                        StatusView(backgroundColor: Color.green, text: "Connected")
                    }
                }
                else {
                    HStack {
                        Text("Status")
                            .font(.subheadline)
                        Spacer()
                        StatusView(backgroundColor: Color.red, text: "Not connected")
                    }
                }
               
                InfoRow(leftSide: "SSID", rightSide: ssid ?? "N/A")
                InfoRow(leftSide: "BSSID", rightSide: bssid ?? "N/A")
                
                if let safeDefaultGateway = defaultGateway {
                    InfoRow(leftSide: "Default Gateway", rightSide: safeDefaultGateway)
                }
                else {
                    InfoRow(leftSide: "Default Gateway", rightSide: "N/A")
                }
                
                if ipv4 != "error" {
                    InfoRow(leftSide: "Internal IP Address", rightSide: ipv4!)
                }
                else {
                    InfoRow(leftSide: "Internal IP Address", rightSide: "N/A")
                }
                
                if connectionStatus == true {
                    if extIPv4 == nil {
                        InfoRow(leftSide: "External IP Address", rightSide: "Loading")
                    }
                    else {
                        InfoRow(leftSide: "External IP Address", rightSide: extIPv4!)
                    }
                }
                else {
                    InfoRow(leftSide: "External IP Address", rightSide: "N/A")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Wi-Fi")
        .onAppear(perform: {
            locationManager.requestWhenInUseAuthorization()
            DispatchQueue.main.async {
                extIPv4 = getExtIPv4()
            }
            
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
