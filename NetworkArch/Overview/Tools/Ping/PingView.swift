//
//  PingView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 02/08/2020.
//

import SwiftUI

struct PingView: View {
    @State var searchBarIP: String
    @State var timer: Timer?
    @ObservedObject var ping = PingManager()
    
    var body: some View {
        VStack {
            SearchBar(text: $searchBarIP, placeholder: "IP Address / Host Name")
                .padding(.horizontal, 15)
            
            let ipToPing = searchBarIP
            
            Spacer()
                .navigationBarTitle("Ping")
                .navigationBarItems(trailing: Button(action: {
                    hideKeyboard()
                    searchBarIP = ""
                    ping.pingResult = []
                    timer?.invalidate()
                    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                        ping.ping(address: ipToPing)
                    })
                }) {
                    Text("Start")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.green)
                        .cornerRadius(10)
                })
            
            List {
                ForEach(ping.pingResult, id: \.self) { ping in
                    Text("\(ping) ms")
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}


struct PingView_Previews: PreviewProvider {
    static var previews: some View {
        PingView(searchBarIP: "")
    }
}

//struct PingData {
//    func ping(address: String) {
//        SimplePingClient.ping(hostname: address) { result in
//            switch result {
//            case .success(let latency):
//                let nLatency = String(format: "%.1f", latency)
//                print("Latency: \(nLatency) ms")
//            case .failure(let error):
//                print("Ping got error: \(error.localizedDescription)")
//            }
//        }
//    }
//}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

