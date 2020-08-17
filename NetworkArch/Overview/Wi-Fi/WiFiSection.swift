//
//  WiFiSection.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI

struct WiFiSection: View {
    let ssid: String
    let wifiImage: String
    let ipAddress: String
    
    var body: some View {
        
        VStack {
            HStack {
                Text(ssid)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: wifiImage)
            }
            .padding(.top, 5)
            
            HStack {
                Text("IP address")
                    .padding(.top)
                Spacer()
                Text(ipAddress)
                    .padding(.top)
            }
            .padding(.bottom)
        }
        
        NavigationLink(destination: WiFiDetailView()) {
            Spacer()
            Text("More Info")
            Spacer()
        }
        .padding(5)
    }
}

struct WiFiSection_Previews: PreviewProvider {
    static var previews: some View {
        WiFiSection(ssid: "SSID", wifiImage: "wifi", ipAddress: "0.0.0.0")
    }
}


