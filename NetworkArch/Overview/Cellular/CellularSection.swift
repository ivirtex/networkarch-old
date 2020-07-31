//
//  CellularSection.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI

struct CellularSection: View {
    var brand: String
    var cellularImage: String
    var ipAddress: String
    
    var body: some View {
        VStack {
            HStack {
                Text(brand)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: cellularImage)
            }
            .padding(.top, 5)
            
            HStack {
                Text("IPv4 address:")
                    .padding(.top)
                Spacer()
                Text(ipAddress)
                    .padding(.top)
            }
            .padding(.bottom)
            
            VStack {
                Text("More Info")
                    .frame(width: UIScreen.main.bounds.width - 85)
                    .padding(5)
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(5)
                    .onTapGesture {
                        print("Button got clicked")
                    }
            }
            .padding(.bottom, 10)
        }
    }
}

struct CellularSection_Previews: PreviewProvider {
    static var previews: some View {
        CellularSection(brand: "brand", cellularImage: "antenna.radiowaves.left.and.right", ipAddress: "0.0.0.0")
    }
}
