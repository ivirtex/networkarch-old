//
//  PingView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 02/08/2020.
//

import SwiftUI

struct PingView: View {
    @ObservedObject var ping = PingManager()
    @State var searchBarIP: String = ""
    @State var timer: Timer?
    @State var finalIP: String?
    @State var shouldDisplayList = false
    
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
        
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Ping")
        .navigationBarItems(trailing: Button(action: {
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
        }) {
            Text("Start")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .padding(5)
                .background(Color.green)
                .cornerRadius(10)
        })
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

