//
//  PacketSection.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 09/08/2020.
//

import SwiftUI

struct PacketSection: View {
    let mac: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(mac)
                    .padding(.vertical, 3)
            }

            Spacer()

            StatusView(backgroundColor: .green, text: "Packet sent")
        }
    }
}

struct PacketSection_Previews: PreviewProvider {
    static var previews: some View {
        PacketSection(mac: "")
    }
}
