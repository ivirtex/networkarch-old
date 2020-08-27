//
//  PingView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 02/08/2020.
//

import SwiftUI

struct PingView: View {
    @ObservedObject private var ping = PingManager()
    @State private var searchBarIP: String = ""
    @State private var timer: Timer?
    @State private var finalIP: String?
    @State private var shouldDisplayList = false
    @State private var isPinging = false
    
    var body: some View {
        let ipToPing = searchBarIP
        
        List {
            Section {
                SearchBar(text: $searchBarIP, placeholder: "IP Address / Host Name")
            }
            
            if shouldDisplayList {
                Section {
                    if self.ping.pingResult != [] {
                        ForEach(ping.pingResult, id: \.self) { ping in
                            HStack {
                                StatusView(backgroundColor: .green, text: "Online")
                                Text(finalIP ?? "")
                                Spacer()
                                Text("\(ping) ms")
                            }
                        }
                    }
                    else {
                        ErrorView(text: "Failed to resolve IP address")
                    }
                }
            }
        }
        .animation(.default)
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Ping")
        .navigationBarItems(trailing: Button(action: {
            if !isPinging {
                isPinging = true
                hideKeyboard()
                searchBarIP = ""
                ping.pingResult = []
                timer?.invalidate()
                shouldDisplayList = true
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                    finalIP = ipToPing
                    DispatchQueue.main.async {
                        ping.ping(address: ipToPing)
                    }
                })
            }
            else {
                timer?.invalidate()
                isPinging = false
            }
        }) {
            if !isPinging {
                Text("Start")
                    .accentColor(Color(.systemGreen))
            }
            else {
                Text("Stop")
                    .accentColor(Color(.systemRed))
            }})
        .onDisappear(perform: {
            timer?.invalidate()
        })
    }
}


struct PingView_Previews: PreviewProvider {
    static var previews: some View {
        PingView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

