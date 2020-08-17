//
//  NSDNSTypeView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 16/08/2020.
//

import SwiftUI

struct NSDNSTypeView: View {
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
            .padding(.bottom, -14)
        }
    }
}

struct NSDNSTypeView_Previews: PreviewProvider {
    static var previews: some View {
        NSDNSTypeView(domainName: "bbc.com", target: "1234", ttl: 128)
    }
}
