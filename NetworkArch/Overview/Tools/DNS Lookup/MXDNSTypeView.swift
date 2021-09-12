//
//  MXDNSTypeView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 16/08/2020.
//

import SwiftUI

struct MXDNSTypeView: View {
    let domainName: String
    let target: String
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
                Text(target)
                Spacer()
            }
            .padding(.bottom, -28)
        }
    }
}

struct MXDNSTypeView_Previews: PreviewProvider {
    static var previews: some View {
        MXDNSTypeView(domainName: "bbc.com", target: "abc", ttl: 128)
    }
}
