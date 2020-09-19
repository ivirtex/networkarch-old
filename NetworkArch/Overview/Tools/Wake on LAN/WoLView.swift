//
//  WoLView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct WoLView: View {
    @State private var timer: Timer?
    @State private var mac: String = ""
    @State private var broadcastAddr: String = ""
    @State private var port: String = ""
    @State private var finalMac: String = ""
    @State private var pError: Error?
    @State private var packetsList: [Result] = []
    
    struct Result: Identifiable {
        var id = UUID()
        var mac: String = ""
        var isSuccessfull: Bool
        var error: Error?
    }
    
    var body: some View {
        List {
            Section {
                TextField("MAC Address", text: $mac)
                TextField("Broadcast Address (optional)", text: $broadcastAddr)
                TextField("Port (optional)", text: $port)
            }
            
            Section {
                ForEach(packetsList) { packet in
                    if packet.isSuccessfull {
                        PacketSection(mac: packet.mac)
                    }
                    else {
                        ErrorSection(errorReason: packet.error!)
                    }
                }
            }
        }
        .animation(.default)
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Wake on LAN")
        .navigationBarItems(trailing: Button(action: {
            let finalPort = UInt16(port)
            var finalBroadcast = broadcastAddr
            
            finalMac = mac
            if self.broadcastAddr.isEmpty && self.finalMac.count == 17 {
                finalBroadcast = "255.255.255.0"
            }
            let computer = Awake.Device(MAC: finalMac, BroadcastAddr: finalBroadcast, Port: finalPort ?? 9)
            hideKeyboard()
            pError = Awake.target(device: computer)
            
            if let error = pError {
                packetsList.append(Result(mac: finalMac, isSuccessfull: false, error: error))
            }
            else {
                print("WoL packet successfully sent")
                packetsList.append(Result(mac: finalMac, isSuccessfull: true))
                finalMac = ""
            }
        })
        {
            Text("Send packet")
                .accentColor(Color(.systemGreen))
        }
        .disabled(self.mac.isEmpty)
        )
    }
}


struct WoLView_Previews: PreviewProvider {
    static var previews: some View {
        WoLView()
    }
}
