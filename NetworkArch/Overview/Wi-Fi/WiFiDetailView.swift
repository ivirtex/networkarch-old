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
    @State var ipv4 = UIDevice.current.ipv4(for: .wifi)
    @State var ipv6 = UIDevice.current.ipv6(for: .wifi)?.split(by: 15)
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
                
                if let finalIPv4 = ipv4 {
                    InfoRow(leftSide: "Internal IPv4", rightSide: finalIPv4)
                }
                else {
                    InfoRow(leftSide: "Internal IPv4", rightSide: "N/A")
                }
                
                if let finalIPv6 = ipv6 {
                    InfoRow(leftSide: "Internal IPv6", rightSide: "\(finalIPv6[0])\n\(finalIPv6[1])")
                }
                else {
                    InfoRow(leftSide: "Internal IPv6", rightSide: "N/A")
                }
                
                if connectionStatus == true {
                    if extIPv4 == nil {
                        InfoRow(leftSide: "External IPv4", rightSide: "Loading")
                    }
                    else {
                        InfoRow(leftSide: "External IPv4", rightSide: extIPv4!)
                    }
                }
                else {
                    InfoRow(leftSide: "External IPv4", rightSide: "N/A")
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
                ipv4 = UIDevice.current.ipv4(for: .wifi)
                ipv6 = UIDevice.current.ipv6(for: .wifi)?.split(by: 15)
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

extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
}
