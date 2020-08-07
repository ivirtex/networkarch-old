//
//  ScannerView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct ScannerView: View {
    var body: some View {
        List {
            Text("PPDJ")
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("LAN Scanner")
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
