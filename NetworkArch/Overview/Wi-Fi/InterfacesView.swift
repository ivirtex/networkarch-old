//
//  InterfacesView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 19/09/2020.
//

import SwiftUI
import NetUtils

struct InterfacesView: View {
    var interfaces = NetUtils.Interface.allInterfaces()
    
    var body: some View {
        Text("Hello, World!")
            .onAppear(perform: {
                for interface in interfaces {
                    print(interface.name)
                }
            })
    }
}

struct InterfacesView_Previews: PreviewProvider {
    static var previews: some View {
        InterfacesView()
    }
}
