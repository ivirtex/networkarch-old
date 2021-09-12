//
//  ErrorSection.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 09/08/2020.
//

import SwiftUI

struct ErrorSection: View {
    var errorReason: Error

    var body: some View {
        HStack {
            Text(errorReason.localizedDescription)

            Spacer()

            StatusView(backgroundColor: .red, text: "Packet not sent")
        }
    }
}

// struct ErrorSection_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorSection()
//    }
// }
