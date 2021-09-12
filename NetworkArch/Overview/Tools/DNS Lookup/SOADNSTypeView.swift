//
//  SOADNSTypeView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 16/08/2020.
//

import SwiftUI

struct SOADNSTypeView: View {
    let domainName: String
    let admin: String
    let host: String
    let expire: Int
    let minimum: Int
    let refresh: Int
    let retry: Int
    let serial: Int
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
                VStack(alignment: .leading) {
                    Text("Admin: \(admin)")
                    Text("Host: \(host)")
                    Text("Expire: \(expire)")
                    Text("Minimum: \(minimum)")
                    Text("Refresh: \(refresh)")
                    Text("Retry: \(retry)")
                    Text("Serial: \(serial)")
                }
                Spacer()
            }
            .padding(.bottom, 5)
        }
    }
}

struct SOADNSTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SOADNSTypeView(domainName: "", admin: "", host: "", expire: 1, minimum: 1, refresh: 1, retry: 1, serial: 1, ttl: 1)
    }
}
