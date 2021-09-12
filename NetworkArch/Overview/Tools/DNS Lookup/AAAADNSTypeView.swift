//
//  AAAADNSTypeView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 16/08/2020.
//

import SwiftUI

struct AAAADNSTypeView: View {
    let domainName: String
    let address: String
    let ttl: Int

    var body: some View {
        VStack {
            HStack {
                Text(domainName)
                    .fontWeight(.bold)
                    .font(.title2)
                Spacer()
                Text("TTL: \(ttl)")
            }
            .padding(.vertical, 5)

            HStack {
                Text(address)
                Spacer()
            }
            .padding(.bottom, -14)
        }
    }
}

struct AAAADNSTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AAAADNSTypeView(domainName: "bbc.com", address: "0.0.0.0", ttl: 128)
    }
}
