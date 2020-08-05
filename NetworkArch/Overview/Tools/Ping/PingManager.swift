//
//  PingManager.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 05/08/2020.
//

import Foundation

class PingManager: ObservableObject {
    @Published var pingResult = [String]()
    
    func ping(address: String) {
        SimplePingClient.ping(hostname: address) { result in
            switch result {
            case .success(let latency):
                let nLatency = String(format: "%.1f", latency)
                self.pingResult.append(nLatency)
                print("Latency: \(nLatency) ms")
            case .failure(let error):
                self.pingResult.append(error.localizedDescription)
                print("Ping got error: \(error.localizedDescription)")
            }
        }
    }
}
