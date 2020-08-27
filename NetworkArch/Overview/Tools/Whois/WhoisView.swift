//
//  WhoisView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct WhoisView: View {
    @State private var ipWhois: String = ""
    @State private var shouldDisplayList = false
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
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
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
            whois.response = ""
            shouldDisplayList = true
            hideKeyboard()
            DispatchQueue.main.async {
                whois.fetchWhois(domainName: ipWhois)
            }
        })
        {
            Text("Start")
                .accentColor(Color(.systemGreen))
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
