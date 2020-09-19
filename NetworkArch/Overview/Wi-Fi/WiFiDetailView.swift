//
//  WiFiDetailView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI
import FGRoute

struct WiFiDetailView: View {
    @AppStorage("Data usage") var isDataUsageAccepted = false
    @State private var isShowing = true
    @State private var ssid = FGRoute.getSSID()
    @State private var bssid = FGRoute.getBSSID()
    @State private var ipv4 = UIDevice.current.ipv4(for: .wifi)
    @State private var ipv6 = UIDevice.current.ipv6(for: .wifi)?.split(by: 15)
    @State private var defaultGateway = FGRoute.getGatewayIP()
    @State private var connectionStatus = FGRoute.isWifiConnected()
    @State private var extIPv4: String? = nil
    @State private var wifiReceived = DataUsage.getDataUsage().wifiReceived
    @State private var wifiSent = DataUsage.getDataUsage().wifiSent
    @State private var timer: Timer?
    
    var body: some View {
        List {
            Section {
                if connectionStatus == true {
                    HStack {
                        Text("Status")
                            .font(.subheadline)
                        Spacer()
                        StatusView(backgroundColor: Color(.systemGreen), text: "Connected")
                    }
                }
                else {
                    HStack {
                        Text("Status")
                            .font(.subheadline)
                        Spacer()
                        StatusView(backgroundColor: Color(.systemRed), text: "Not connected")
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
                    if let safeExtIPv4 = extIPv4 {
                        InfoRow(leftSide: "External IPv4", rightSide: safeExtIPv4)
                    }
                    else {
                        HStack {
                            Text("External IPv4")
                                .font(.subheadline)
                            Spacer()
                            ProgressView()
                        }
                    }
                }
                else {
                    InfoRow(leftSide: "External IPv4", rightSide: "N/A")
                }
                
                NavigationLink(destination: InterfacesView()) {
                    Text("Interfaces")
                }
            }
            
            Section(header: Text("Data usage")) {
                InfoRow(leftSide: "Wi-Fi data received", rightSide: String(wifiReceived / 1000000) + "MB")
                
                InfoRow(leftSide: "Wi-Fi data sent", rightSide: String(wifiSent / 1000000) + "MB")
            }
            
            if !isDataUsageAccepted {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .padding(.trailing, 5)
                    Text("Data usage is measured since the device's last boot")
                    Button(action: {
                        isDataUsageAccepted = true
                    })
                    {
                        Text("OK")
                            .bold()
                            .padding(.horizontal)
                    }
                }
                .foregroundColor(.black)
                .listRowBackground(Color(.systemYellow))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Wi-Fi")
        .onAppear(perform: {
            DispatchQueue.global().async {
                extIPv4 = getExtIPv4()
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                ssid = FGRoute.getSSID()
                bssid = FGRoute.getBSSID()
                ipv4 = UIDevice.current.ipv4(for: .wifi)
                ipv6 = UIDevice.current.ipv6(for: .wifi)?.split(by: 15)
                defaultGateway = FGRoute.getGatewayIP()
                connectionStatus = FGRoute.isWifiConnected()
                wifiReceived = DataUsage.getDataUsage().wifiReceived
                wifiSent = DataUsage.getDataUsage().wifiSent
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
