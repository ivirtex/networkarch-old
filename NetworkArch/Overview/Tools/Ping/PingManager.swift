//
//  PingManager.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 05/08/2020.
//

import Foundation

class PingManager: ObservableObject {
    struct Result: Identifiable {
        var id = UUID()
        var latency: Float?
        var isSuccessfull: Bool
    }
    
    @Published var pingResult = [Result]()
    
    func ping(address: String) {
        SimplePingClient.ping(hostname: address) { result in
            switch result {
            case .success(let latency):
                let nLatency = Float(String(format: "%.1f", latency))!
                self.pingResult.append(Result(latency: nLatency, isSuccessfull: true))
                print("Latency: \(nLatency) ms")
            case .failure(let error):
                self.pingResult.append(Result(isSuccessfull: false))
                print("Ping got error: \(error.localizedDescription)")
            }
        }
    }
}
