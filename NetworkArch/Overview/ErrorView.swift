//
//  ErrorView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 13/08/2020.
//

import SwiftUI

struct ErrorView: View {
    let text: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(.systemRed))
                .cornerRadius(10)
            HStack {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.white)
                Spacer()
                Text(text)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(text: "hello")
    }
}
