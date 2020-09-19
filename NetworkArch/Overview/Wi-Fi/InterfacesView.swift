//
//  InterfacesView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 19/09/2020.
//

import SwiftUI
import NetUtils

struct InterfacesView: View {
    @State private var interfaces = NetUtils.Interface.allInterfaces()
    
    var body: some View {
        List {
            ForEach(interfaces) { interface in
                Section {
                    if interface.isUp {
                        if interface.isRunning {
                            HStack {
                                StatusView(backgroundColor: Color(.systemGreen), text: "Up")
                                StatusView(backgroundColor: Color(.systemGreen), text: "Running")
                                Text("\(interface.name)/\(interface.family.toString())")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(Color(.systemGreen))
                            }
                            HStack {
                                Text("Address")
                                Spacer()
                                Text(interface.address ?? "N/A")
                            }
//                            HStack {
//                                Text("Interface netmask")
//                                Spacer()
//                                Text(String(describing: interface.addressBytes))
//                            }
                        }
                        else {
                            HStack {
                                StatusView(backgroundColor: Color(.systemGreen), text: "Up")
                                StatusView(backgroundColor: Color(.systemRed), text: "Not running")
                                Text(interface.name)
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(Color(.systemYellow))
                            }
                        }
                    }
                    else {
                        HStack {
                            StatusView(backgroundColor: Color(.systemRed), text: "Not up")
                            StatusView(backgroundColor: Color(.systemRed), text: "Not running")
                            Text(interface.name)
                                .font(.headline)
                            Spacer()
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Interfaces")
    }
}

struct InterfacesView_Previews: PreviewProvider {
    static var previews: some View {
        InterfacesView()
    }
}
