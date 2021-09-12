//
//  StatusView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 01/08/2020.
//

import SwiftUI

struct StatusView: View {
    let backgroundColor: Color
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.white)
            .padding(5)
            .background(backgroundColor)
            .cornerRadius(5)
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(backgroundColor: Color.green, text: "Online")
    }
}
