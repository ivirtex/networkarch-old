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
    @State private var shouldDisplayStats = false
    @State private var pingSummed: Float = 0
    @State private var packetsNumber: Float = 0
    private var avgPing: Float {
        return pingSummed / packetsNumber
    }
    private var minPing: Float {
        return ping.pingResult.map{$0.latency}.min()!
    }
    private var maxPing: Float {
        return ping.pingResult.map{$0.latency}.max()!
    }
    
    var body: some View {
        let ipToPing = searchBarIP
        
        List {
            Section {
                SearchBar(text: $searchBarIP, placeholder: "IP Address / Host Name")
            }
            
            if shouldDisplayStats {
                if !ping.pingResult.isEmpty {
                    Section(header: Text("Ping statistics")) {
                        HStack {
                            Text("Minimum")
                            Spacer()
                            Text(String(format: "%.1f", minPing) + " ms")
                        }
                        HStack {
                            Text("Average")
                            Spacer()
                            if avgPing < 50 {
                                Text(String(format: "%.1f", avgPing) + " ms")
                                    .foregroundColor(.green)
                            }
                            else if avgPing < 100 {
                                Text(String(format: "%.1f", avgPing) + " ms")
                                    .foregroundColor(.yellow)
                            }
                            else {
                                Text(String(format: "%.1f", avgPing) + " ms")
                                    .foregroundColor(.red)
                            }
                        }
                        HStack {
                            Text("Maximum")
                            Spacer()
                            Text(String(format: "%.1f", maxPing) + " ms")
                        }
                    }
                }
            }
            
            if shouldDisplayList {
                Section {
                    ForEach(ping.pingResult) { result in
                        HStack {
                            if result.isSuccessfull {
                                StatusView(backgroundColor: .green, text: "Online")
                                Text(finalIP ?? "")
                                Spacer()
                                Text(String(format: "%.1f", result.latency) + " ms")
                            }
                            else {
                                StatusView(backgroundColor: .red, text: "Offline")
                                Spacer()
                                Text("Failed to resolve IP address")
                            }
                        }
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
                shouldDisplayStats = false
                hideKeyboard()
                searchBarIP = ""
                ping.pingResult = []
                pingSummed = 0
                packetsNumber = 0
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
                shouldDisplayStats = true
                if !ping.pingResult.isEmpty {
                    for result in ping.pingResult {
                        if result.isSuccessfull {
                            pingSummed += result.latency
                            packetsNumber += 1
                        }
                    }
                }
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

