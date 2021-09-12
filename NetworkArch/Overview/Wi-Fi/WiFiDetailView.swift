//
//  WiFiDetailView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import FGRoute
import NetUtils
import SwiftUI
import SwiftUICharts

struct WiFiDetailView: View {
    @AppStorage("Data usage") var isDataUsageAccepted = false
    @AppStorage("WiFi received") var wifiReceivedTotal: Double = 0
    @AppStorage("WiFi sent") var wifiSentTotal: Double = 0
    @State private var isShowing = true
    @State private var ssid = FGRoute.getSSID()
    @State private var bssid = FGRoute.getBSSID()
    @State private var ipv4 = UIDevice.current.ipv4(for: .wifi)
    @State private var ipv6 = NetUtils.Interface.allInterfaces().first(where: { $0.name == "en0" && $0.family.toString() == "IPv6" })
    @State private var defaultGateway = FGRoute.getGatewayIP()
    @State private var connectionStatus = FGRoute.isWifiConnected()
    @State private var extIPv4: String?
    @State private var wifiReceived = DataUsage.getDataUsage().wifiReceived
    @State private var wifiSent = DataUsage.getDataUsage().wifiSent
    @State private var en0 = NetUtils.Interface.allInterfaces().first(where: { $0.name == "en0" && $0.family.toString() == "IPv4" })
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
                } else {
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
                } else {
                    InfoRow(leftSide: "Default Gateway", rightSide: "N/A")
                }

                if let safeEn0 = en0 {
                    InfoRow(leftSide: "Subnet Mask", rightSide: safeEn0.netmask ?? "N/A")
                } else {
                    InfoRow(leftSide: "Subnet Mask", rightSide: "N/A")
                }

                if let finalIPv4 = ipv4 {
                    InfoRow(leftSide: "Internal IPv4", rightSide: finalIPv4)
                } else {
                    InfoRow(leftSide: "Internal IPv4", rightSide: "N/A")
                }

                if let safeIPv6 = ipv6 {
                    InfoRow(leftSide: "Internal IPv6", rightSide: safeIPv6.address ?? "N/A")
                } else {
                    InfoRow(leftSide: "Internal IPv6", rightSide: "N/A")
                }

                if connectionStatus == true {
                    if let safeExtIPv4 = extIPv4 {
                        InfoRow(leftSide: "External IPv4", rightSide: safeExtIPv4)
                    } else {
                        HStack {
                            Text("External IPv4")
                                .font(.subheadline)
                            Spacer()
                            ProgressView()
                        }
                    }
                } else {
                    InfoRow(leftSide: "External IPv4", rightSide: "N/A")
                }

                NavigationLink(destination: InterfacesView()) {
                    Text("Interfaces")
                        .font(.subheadline)
                }
            }

            Section(header: Text("Data usage")) {
                InfoRow(leftSide: "Wi-Fi data received", rightSide: ByteCountFormatter.string(fromByteCount: Int64(wifiReceivedTotal), countStyle: .binary))

                InfoRow(leftSide: "Wi-Fi data sent", rightSide: ByteCountFormatter.string(fromByteCount: Int64(wifiSentTotal), countStyle: .binary))
            }

            if !isDataUsageAccepted {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .padding(.trailing, 5)
                    Text("Data usage is measured since the device's last boot")
                    Spacer()
                    Button(action: {
                        isDataUsageAccepted = true
                    }) {
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

            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                ssid = FGRoute.getSSID()
                bssid = FGRoute.getBSSID()
                ipv4 = UIDevice.current.ipv4(for: .wifi)
                ipv6 = NetUtils.Interface.allInterfaces().first(where: { $0.name == "en0" && $0.family.toString() == "IPv6" })
                defaultGateway = FGRoute.getGatewayIP()
                connectionStatus = FGRoute.isWifiConnected()
                en0 = NetUtils.Interface.allInterfaces().first(where: { $0.name == "en0" && $0.family.toString() == "IPv4" })
                wifiReceivedTotal = Double(DataUsage.getDataUsage().wifiReceived)
                wifiSentTotal = Double(DataUsage.getDataUsage().wifiSent)
            })
        })
    }
}

struct WiFiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WiFiDetailView()
    }
}
