//
//  WoLView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct WoLView: View {
    @State var timer: Timer?
    @State var mac: String = ""
    @State var broadcastAddr: String = ""
    @State var port: String = ""
    @State var finalMac: String = ""
    @State var pError: Error?
    @State var shouldDisplayList = false
    @State var packetsList = [String]()
    
    var body: some View {
        List {
            Section {
                TextField("MAC Address", text: $mac)
                TextField("Broadcast Address (optional)", text: $broadcastAddr)
                TextField("Port (optional)", text: $port)
            }
            
            if shouldDisplayList {
                Section {
                    ForEach(packetsList, id: \.self) { packet in
                        if packet == "success" {
                            PacketSection(mac: mac)
                        }
                        else {
                            ErrorSection()
                        }
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
            shouldDisplayList = true
            hideKeyboard()
            pError = Awake.target(device: computer)
            
            if let error = pError {
                print(error)
                packetsList.append("fail")
            }
            else {
                print("WoL packet successfully sent")
                packetsList.append("success")
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
