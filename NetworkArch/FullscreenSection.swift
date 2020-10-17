//
//  FullscreenSection.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 17/10/2020.
//

import Foundation
import SwiftUI

struct FullscreenSection<T>: View where T: ObservableObject {
        typealias Action = () -> Void
        let text: String
        @ObservedObject var ad: T
        var keyPath: ReferenceWritableKeyPath<T,Bool>
        var action: Action
        
        var body: some View {
            Section(header: Text(text.uppercased())) {
                HStack {
                    Text(ad[keyPath: keyPath] ? "Ready" : "Loading")
                    Spacer()
                    ProgressView()
                }
                if ad[keyPath: keyPath] {
                    Button(action: action) {
                        Text("Show \(text.lowercased())")
                    }.transition(.slide)
                }
            }
        }
    }
