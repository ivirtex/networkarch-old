//
//  InfoRow.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI

struct InfoRow: View {
    var leftSide: String
    var rightSide: String
    
    var body: some View {
        HStack {
            Text(leftSide)
                .font(.subheadline)
            Spacer()
            Text(rightSide)
                .font(.subheadline)
        }
    }
}

struct InfoRow_Previews: PreviewProvider {
    static var previews: some View {
        InfoRow(leftSide: "Left", rightSide: "Right")
    }
}
