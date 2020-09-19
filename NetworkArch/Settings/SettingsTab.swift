//
//  SettingsTab.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI
import SwiftyStoreKit
import MessageUI

struct SettingsTab: View {
    let overview = OverviewTab()
    @State private var showingAlert = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button("Restore Purchases") {
                        SwiftyStoreKit.restorePurchases(atomically: true) { results in
                            if results.restoreFailedPurchases.count > 0 {
                                print("Restore Failed: \(results.restoreFailedPurchases)")
                            }
                            else if results.restoredPurchases.count > 0 {
                                print("Restore Success: \(results.restoredPurchases)")
                                showingAlert = true
                                for item in results.restoredPurchases {
                                    switch item.productId {
                                    case Constants.ProductID.adsProductID:
                                        overview.areAdsRemoved = true
                                    case Constants.ProductID.whoisProductID:
                                        overview.isWhoisUnlocked = true
                                    case Constants.ProductID.dnsProductID:
                                        overview.isDNSUnlocked = true
                                    default:
                                        break
                                    }
                                    print(item.productId)
                                }
                            }
                            else {
                                print("Nothing to Restore")
                            }
                        }
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Restore success."))
                    }
                }
                
                Section(header: Text("Purchases")) {
                    Button("Remove Ads") {
                        SwiftyStoreKit.purchaseProduct(Constants.ProductID.adsProductID, quantity: 1, atomically: true) { (result) in
                            switch result {
                            case .success(let purchase):
                                overview.areAdsRemoved = true
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
                    }
                    .disabled(overview.areAdsRemoved)
                    
                    Button("Unlock Whois") {
                        SwiftyStoreKit.purchaseProduct(Constants.ProductID.whoisProductID, quantity: 1, atomically: true) { (result) in
                            switch result {
                            case .success(let purchase):
                                overview.isWhoisUnlocked = true
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
                    }
                    .disabled(overview.isWhoisUnlocked)
                    
                    Button("Unlock DNS Lookup") {
                        SwiftyStoreKit.purchaseProduct(Constants.ProductID.dnsProductID, quantity: 1, atomically: true) { (result) in
                            switch result {
                            case .success(let purchase):
                                overview.isDNSUnlocked = true
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
                    }
                    .disabled(overview.isDNSUnlocked)
                }
                
                Section(header: Text("Support")) {
                    Button(action: {
                        self.isShowingMailView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Send an email")
                        }
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(result: self.$result)
                    }
                }
                
                Section(header: Text("App Info"), footer: Text("Made with ❤️ by ivirtex")) {
                    InfoRow(leftSide: "App Name", rightSide: "NetworkArch")
                    InfoRow(leftSide: "Compatibility", rightSide: "iPhone, iPad, Mac (ARM)")
                    InfoRow(leftSide: "Version", rightSide: "1.0b9")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsTab_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTab()
    }
}
