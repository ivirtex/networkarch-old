//
//  WhoisModalBuyView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 26/08/2020.
//

import SwiftUI
import SwiftyStoreKit

struct WhoisModalBuyView: View {
    var overview = OverviewTab()
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Whois")
                .font(.title)
                .bold()
                .padding()
                .padding(.top, 10)
            Spacer()
            Text("Whois is a query and response protocol that is widely used for querying databases that store the registered users or assignees of an Internet resource, such as a domain name or an IP address block.")
                .padding(.horizontal, 20)
                .multilineTextAlignment(.leading)
            Image("whoisModal")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Button(action: {
                SwiftyStoreKit.purchaseProduct(Constants.ProductID.whoisProductID, quantity: 1, atomically: true) { (result) in
                    switch result {
                    case .success(let purchase):
                        overview.isWhoisUnlocked = true
                        self.isPresented = false
                        print("Purchase Success: \(purchase.productId)")
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        default: print((error as NSError).localizedDescription)
                        }
                    }
                }
            }){
                Text("Purchase")
                    .customButton()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, 15)
            .padding(.bottom, 25)
            .padding(.horizontal, 25)
        }
    }
}

//struct WhoisModalBuyView_Previews: PreviewProvider {
//    static var previews: some View {
//        WhoisModalBuyView(isPresented: //)
//    }
//}
