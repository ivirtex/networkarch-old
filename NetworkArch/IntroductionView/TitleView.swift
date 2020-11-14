//
//  TitleView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 14/11/2020.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack {
            Image("networkarch icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, alignment: .center)
                .cornerRadius(15)
                .accessibility(hidden: true)

            Text("Welcome to")
                .customTitleText()

            Text("NetworkArch")
                .customTitleText()
                .foregroundColor(.mainColor)
                .padding(.bottom)
        }
    }
}
