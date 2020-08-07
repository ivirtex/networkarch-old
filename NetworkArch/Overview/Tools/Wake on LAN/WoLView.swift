//
//  WoLView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct WoLView: View {
    var body: some View {
        List {
            Text("PPDJ")
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Wake on LAN")
    }
}

struct WoLView_Previews: PreviewProvider {
    static var previews: some View {
        WoLView()
    }
}
