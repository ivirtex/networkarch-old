//
//  WhoisView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct WhoisView: View {
    @State var ipWhois: String
    @State var shouldDisplayList = false
    @ObservedObject var whois = WhoisManager()
    
    var body: some View {
        List {
            Section {
                SearchBar(text: $ipWhois, placeholder: "IP / AS / Domain Name")
            }
            
            if shouldDisplayList {
                Section {
                    Text(String(describing: whois.response ?? "Loading" as NSObject))
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button(action: {
            DispatchQueue.main.async {
                shouldDisplayList.toggle()
                whois.fetchWhois()
            }
        })
        {
            Text("Start")
        })
        .navigationBarTitle("Whois")
    }
}

struct WhoisView_Previews: PreviewProvider {
    static var previews: some View {
        WhoisView(ipWhois: "")
    }
}
