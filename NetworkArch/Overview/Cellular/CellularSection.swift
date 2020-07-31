//
//  CellularSection.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI

struct CellularSection: View {
    var carrier: String
    var cellularImage: String
    var ipAddress: String
    
    var body: some View {
        VStack {
            HStack {
                Text(carrier)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: cellularImage)
            }
            .padding(.top, 5)
            
            HStack {
                Text("IP address:")
                    .padding(.top)
                Spacer()
                Text(ipAddress)
                    .padding(.top)
            }
            .padding(.bottom)
        }
        NavigationLink(destination: CellularDetailView()) {
            Spacer()
            Text("More Info")
            Spacer()
        }
        .padding(5)
    }
}

struct CellularSection_Previews: PreviewProvider {
    static var previews: some View {
        CellularSection(carrier: "brand", cellularImage: "antenna.radiowaves.left.and.right", ipAddress: "0.0.0.0")
    }
}
