//
//  DNSLookupView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct DNSLookupView: View {
    var body: some View {
        List {
            Text("PPDJ")
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("DNS Lookup")
    }
}

struct DNSLookupView_Previews: PreviewProvider {
    static var previews: some View {
        DNSLookupView()
    }
}
