//
//  InformationContainerView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 14/11/2020.
//

import SwiftUI

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Wi-Fi information", subTitle: "Detailed information about your Wi-Fi network and network interfaces.", imageName: "wifi")

            InformationDetailView(title: "Cellular information", subTitle: "Detailed information about your cellular network.", imageName: "antenna.radiowaves.left.and.right")

            InformationDetailView(title: "Utilites", subTitle: "Get access to various useful diagnostic tools such as ping, WOL, Whois and DNS Lookup.", imageName: "gear")
        }
        .padding(.horizontal)
    }
}
