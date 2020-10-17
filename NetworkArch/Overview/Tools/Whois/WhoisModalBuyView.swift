//
//  WhoisModalBuyView.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 26/08/2020.
//

import SwiftUI
import SwiftyStoreKit

struct WhoisModalBuyView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var ad = AdvertisingProvider.shared
    private let overview = OverviewTab()
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Whois is a query and response protocol that is widely used for querying databases that store the assignees of an Internet resource, such as a domain name, an IP address block etc.")
                .padding(.horizontal, 20)
                .multilineTextAlignment(.leading)
            Image("whoisModal")
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack {
                Button(action: {
                    SwiftyStoreKit.purchaseProduct(Constants.ProductID.whoisProductID, quantity: 1, atomically: true) { (result) in
                        switch result {
                        case .success(let purchase):
                            overview.isWhoisUnlocked = true
                            self.presentationMode.wrappedValue.dismiss()
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
                    Text("Buy")
                        .font(.headline)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Capsule().fill(Color.blue))
                        .foregroundColor(Color.white)
                }
                
                Button(action: {
                    ad.presentRewarded { (_) in
                        overview.whoisAdWatchedTimes = 1
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Watch an Ad")
                        .font(.headline)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Capsule().strokeBorder(Color(.systemBlue), lineWidth: 3))
                        .background(Capsule().fill(Color.white))
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.top, 15)
            .padding(.bottom, 25)
            .padding(.horizontal, 25)
            .navigationBarTitle("Whois")
        }
    }
}

//struct WhoisModalBuyView_Previews: PreviewProvider {
//    static var previews: some View {
//        WhoisModalBuyView(isPresented: //)
//    }
//}
