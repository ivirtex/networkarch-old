//
//  TXTDNSTypeView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 17/08/2020.
//

import SwiftUI

struct TXTDNSTypeView: View {
    let domainName: String
    let strings: String
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
                Text(strings)
                Spacer()
            }
            .padding(.bottom, -14)
        }
    }
}

struct TXTDNSTypeView_Previews: PreviewProvider {
    static var previews: some View {
        TXTDNSTypeView(domainName: "", strings: "", ttl: 12)
    }
}
