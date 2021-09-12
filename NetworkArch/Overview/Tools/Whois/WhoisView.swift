//
//  WhoisView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 08/08/2020.
//

import SwiftUI

struct WhoisView: View {
    @ObservedObject private var whois = WhoisManager()
    @State private var addressWhois: String = ""
    @State private var shouldDisplayList = false
    private var overview = OverviewTab()

    var body: some View {
        List {
            Section {
                SearchBar(text: $addressWhois, placeholder: "IP / AS / Domain Name")
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
                        } else {
                            Text(whois.response)
                                .font(.subheadline)
                        }
                    }
                } else {
                    Section {
                        HStack {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.white)
                            Spacer()
                            Text("Invalid domain")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .listRowBackground(Color(.systemRed))
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button(action: {
            let finalAddress = addressWhois
            whois.error = false
            addressWhois = ""
            whois.response = ""
            shouldDisplayList = true
            hideKeyboard()
            DispatchQueue.main.async {
                whois.fetchWhois(domainName: finalAddress)
            }
        }) {
            Text("Start")
                .accentColor(Color(.systemGreen))
        }
        .disabled(self.addressWhois.isEmpty)
        )
        .navigationBarTitle("Whois")
        .animation(.default)
    }
}

struct WhoisView_Previews: PreviewProvider {
    static var previews: some View {
        WhoisView()
    }
}
