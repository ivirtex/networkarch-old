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
    
    var body: some View {
        List {
            Section(header: CellularHeader()) {
                if let safeCarrierInfo = carrierInfo {
                    InfoRow(leftSide: "Carrier", rightSide: safeCarrierInfo.first?.value.carrierName ?? "Not available")
                    
                    InfoRow(leftSide: "ISO Country Code", rightSide: safeCarrierInfo.first?.value.isoCountryCode ?? "Not available")
                    
                    InfoRow(leftSide: "Mobile Country Code", rightSide: safeCarrierInfo.first?.value.mobileCountryCode ?? "Not available")
                    
                    InfoRow(leftSide: "Mobile Network Code", rightSide: safeCarrierInfo.first?.value.mobileNetworkCode ?? "Not available")
                    
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
                    InfoRow(leftSide: "Carrier", rightSide: "Not available")
                    
                    InfoRow(leftSide: "ISO Country Code", rightSide: "Not available")
                    
                    InfoRow(leftSide: "Mobile Country Code", rightSide: "Not available")
                    
                    InfoRow(leftSide: "Mobile Network Code", rightSide: "Not available")
                    
                    InfoRow(leftSide: "VoIP Support", rightSide: "Not available")

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
