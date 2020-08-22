//
//  SearchBar.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 04/08/2020.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(placeholder, text: $text)
                .keyboardType(.URL)
            if text != "" {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .foregroundColor(backgroundColor)
                    .onTapGesture {
                        withAnimation {
                            self.text = ""
                        }
                    }
            }
        }
        .cornerRadius(12)
    }
    
    @Environment(\.colorScheme) var colorScheme

    var backgroundColor: Color {
      if colorScheme == .dark {
           return Color(.systemGray5)
       } else {
           return Color(.systemGray6)
       }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), placeholder: "IP Address")
    }
}



