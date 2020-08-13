//
//  WoLView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI
import FGRoute

struct WoLView: View {
    @State var isWifiConnected = FGRoute.isWifiConnected()
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
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Wake on LAN")
        .navigationBarItems(trailing: Button(action: {
            let finalPort = UInt16(port)
            let computer = Awake.Device(MAC: mac, BroadcastAddr: broadcastAddr, Port: finalPort ?? 0)
            shouldDisplayList = true
            hideKeyboard()
            pError = Awake.target(device: computer)
            finalMac = mac
            
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
        }
        .disabled(!isWifiConnected || self.mac.isEmpty)
        )
        .onAppear(perform: {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                isWifiConnected = FGRoute.isWifiConnected()
            })
        })
    }
}


struct WoLView_Previews: PreviewProvider {
    static var previews: some View {
        WoLView()
    }
}
