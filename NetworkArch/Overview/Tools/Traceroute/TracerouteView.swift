//
//  TracerouteView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct TracerouteView: View {
    var body: some View {
        List {
            Text("PPDJ")
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Traceroute")
    }
}

struct TracerouteView_Previews: PreviewProvider {
    static var previews: some View {
        TracerouteView()
    }
}
