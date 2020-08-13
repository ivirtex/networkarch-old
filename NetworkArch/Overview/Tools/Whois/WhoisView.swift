//
//  WhoisView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct WhoisView: View {
    @State var ipWhois: String = ""
    @State var shouldDisplayList = false
    @ObservedObject var whois = WhoisManager()
    
    var body: some View {
        List {
            Section {
                SearchBar(text: $ipWhois, placeholder: "IP / AS / Domain Name")
            }
            
            if shouldDisplayList {
                if whois.error == false {
                    Section {
                        if whois.response == "" {
                            ProgressView()
                                .multilineTextAlignment(.center)
                        }
                        else {
                            Text(whois.response)
                                .font(.subheadline)
                        }
                    }
                }
                else {
                    Section {
                        ErrorView(text: "Invalid Domain")
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button(action: {
            shouldDisplayList = false
            shouldDisplayList = true
            DispatchQueue.main.async {
                whois.fetchWhois(domainName: ipWhois)
                hideKeyboard()
            }
        })
        {
            Text("Start")
        }
        .disabled(self.ipWhois.isEmpty)
        )
        .navigationBarTitle("Whois")
    }
}

struct WhoisView_Previews: PreviewProvider {
    static var previews: some View {
        WhoisView()
    }
}
