//
//  CellularDetailView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI

let carrierDetail = CellularData()
let wifiDetailView = WiFiDetailView()

struct CellularDetailView: View {
    @AppStorage("Cellular received") var cellularReceivedTotal: Double = 0
    @AppStorage("Cellular sent") var cellularSentTotal: Double = 0
    @State private var carrierInfo = carrierDetail.carrierDetail
    @State private var carrierRadioTechnologyRaw = carrierDetail.carrierTechnology
    @State private var cellularIPv4 = UIDevice.current.ipv4(for: .cellular)
    @State private var cellularIPv6 = UIDevice.current.ipv6(for: .cellular)
    @State private var cellularReceived = DataUsage.getDataUsage().wirelessWanDataReceived
    @State private var cellularSent = DataUsage.getDataUsage().wirelessWanDataSent
    @State private var timer: Timer?

    var body: some View {
        List {
            Section {
                if let safeCarrierInfo = carrierInfo {
                    InfoRow(leftSide: "Carrier", rightSide: safeCarrierInfo.first?.value.carrierName ?? "N/A")

                    InfoRow(leftSide: "ISO Country Code", rightSide: safeCarrierInfo.first?.value.isoCountryCode ?? "N/A")

                    InfoRow(leftSide: "Mobile Country Code", rightSide: safeCarrierInfo.first?.value.mobileCountryCode ?? "N/A")

                    InfoRow(leftSide: "Mobile Network Code", rightSide: safeCarrierInfo.first?.value.mobileNetworkCode ?? "N/A")

                    if let safeCarrierRadio = carrierRadioTechnologyRaw {
                        InfoRow(leftSide: "Radio Access Technology", rightSide: CellularRadioConstants.radioTechnology[safeCarrierRadio.first?.value ?? "N/A"] ?? "N/A")
                    } else {
                        InfoRow(leftSide: "Radio Access Technology", rightSide: "N/A")
                    }

                    if let safeCellularIPv4 = cellularIPv4 {
                        InfoRow(leftSide: "IPv4 Address", rightSide: safeCellularIPv4)
                    } else {
                        InfoRow(leftSide: "IPv4 Address", rightSide: "N/A")
                    }

                    if let safeCellularIPv6 = cellularIPv6 {
                        InfoRow(leftSide: "IPv6 Address", rightSide: safeCellularIPv6)
                    } else {
                        InfoRow(leftSide: "IPv6 Address", rightSide: "N/A")
                    }

                    if safeCarrierInfo.first?.value.allowsVOIP == true {
                        HStack {
                            Text("VoIP Support")
                                .font(.subheadline)
                            Spacer()
                            StatusView(backgroundColor: Color.green, text: "Yes")
                        }
                    } else {
                        HStack {
                            Text("VoIP Support")
                                .font(.subheadline)
                            Spacer()
                            StatusView(backgroundColor: Color.red, text: "No")
                        }
                    }
                } else {
                    InfoRow(leftSide: "Carrier", rightSide: "N/A")

                    InfoRow(leftSide: "ISO Country Code", rightSide: "N/A")

                    InfoRow(leftSide: "Mobile Country Code", rightSide: "N/A")

                    InfoRow(leftSide: "Mobile Network Code", rightSide: "N/A")

                    InfoRow(leftSide: "VoIP Support", rightSide: "N/A")

                    InfoRow(leftSide: "IPv4 Address", rightSide: "N/A")

                    InfoRow(leftSide: "IPv6 Address", rightSide: "N/A")

                    InfoRow(leftSide: "Radio Access Technology", rightSide: "N/A")
                }
            }

            Section(header: Text("Data usage")) {
                InfoRow(leftSide: "Cellular data received", rightSide: ByteCountFormatter.string(fromByteCount: Int64(cellularReceivedTotal), countStyle: .binary))

                InfoRow(leftSide: "Cellular data sent", rightSide: ByteCountFormatter.string(fromByteCount: Int64(cellularSentTotal), countStyle: .binary))
            }

            if !wifiDetailView.isDataUsageAccepted {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .padding(.trailing, 5)
                    Text("Data usage is measured since the device's last boot")
                    Button(action: {
                        wifiDetailView.isDataUsageAccepted = true
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
        .navigationBarTitle("Cellular Network")
        .onAppear(perform: {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                carrierInfo = carrierDetail.carrierDetail
                carrierRadioTechnologyRaw = carrier.carrierTechnology
                cellularIPv4 = UIDevice.current.ipv4(for: .cellular)
                cellularIPv6 = UIDevice.current.ipv6(for: .cellular)
                cellularReceivedTotal = Double(DataUsage.getDataUsage().wirelessWanDataReceived)
                cellularSentTotal = Double(DataUsage.getDataUsage().wirelessWanDataSent)
            })
        })
    }
}

struct CellularDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CellularDetailView()
    }
}
