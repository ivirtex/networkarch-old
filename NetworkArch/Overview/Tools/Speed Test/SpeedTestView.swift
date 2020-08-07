//
//  SpeedTestView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct SpeedTestView: View {
    var body: some View {
        List {
            Text("PPDJ")
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Speed Test")
    }
}

struct SpeedTestView_Previews: PreviewProvider {
    static var previews: some View {
        SpeedTestView()
    }
}
