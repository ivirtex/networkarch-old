//
//  IntroductionView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 14/11/2020.
//

import SwiftUI

struct IntroductionView: View {
    @Binding var isPresented: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Spacer()

                TitleView()

                InformationContainerView()

                Spacer(minLength: 30)

                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    isPresented = false
                    ContentView.launchTimes += 1
                }) {
                    Text("Continue")
                        .customButton()
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black).edgesIgnoringSafeArea(.all)
    }
}
