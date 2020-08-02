//
//  CellularDetailView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI

let carrierDetail = CellularData()

struct CellularDetailView: View {
    @State var carrierInfo = carrierDetail.carrierDetail
    @State var carrierRadioTechnologyRaw = carrierDetail.carrierTechnology
    
    var body: some View {
        List {
            Section(header: CellularHeader()) {
                if let safeCarrierInfo = carrierInfo {
                    InfoRow(leftSide: "Carrier", rightSide: safeCarrierInfo.first?.value.carrierName ?? "N/A")
                    
                    InfoRow(leftSide: "ISO Country Code", rightSide: safeCarrierInfo.first?.value.isoCountryCode ?? "N/A")
                    
                    InfoRow(leftSide: "Mobile Country Code", rightSide: safeCarrierInfo.first?.value.mobileCountryCode ?? "N/A")
                    
                    InfoRow(leftSide: "Mobile Network Code", rightSide: safeCarrierInfo.first?.value.mobileNetworkCode ?? "N/A")
                    
                    if let safeCarrierRadio = carrierRadioTechnologyRaw {
                        InfoRow(leftSide: "Radio Access Technology", rightSide: CellularRadioConstants.radioTechnology[safeCarrierRadio.first!.value] ?? "N/A")
                    }
                    else {
                        InfoRow(leftSide: "Radio Access Technology", rightSide: "N/A")
                    }
                    
                    if safeCarrierInfo.first?.value.allowsVOIP == true {
                        HStack {
                            Text("VoIP Support")
                                .font(.subheadline)
                            Spacer()
                            StatusView(backgroundColor: Color.green, text: "Yes")
                        }
                    }
                    else {
                        HStack {
                            Text("VoIP Support")
                                .font(.subheadline)
                            Spacer()
                            StatusView(backgroundColor: Color.red, text: "No")
                        }
                    }
                }
                
                else {
                    InfoRow(leftSide: "Carrier", rightSide: "N/A")
                    
                    InfoRow(leftSide: "ISO Country Code", rightSide: "N/A")
                    
                    InfoRow(leftSide: "Mobile Country Code", rightSide: "N/A")
                    
                    InfoRow(leftSide: "Mobile Network Code", rightSide: "N/A")
                    
                    InfoRow(leftSide: "VoIP Support", rightSide: "N/A")
                    
                    InfoRow(leftSide: "Radio Access Technology", rightSide: "N/A")

                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct CellularDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CellularDetailView()
    }
}
