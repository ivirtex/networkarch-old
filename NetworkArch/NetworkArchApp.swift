//
//  NetworkArchApp.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI
import GoogleMobileAds
import SwiftyStoreKit

@main
struct NetworkArchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                    SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                            for purchase in purchases {
                                switch purchase.transaction.transactionState {
                                case .purchased, .restored:
                                    if purchase.needsFinishTransaction {
                                        // Deliver content from server, then:
                                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                                    }
                                    // Unlock content
                                case .failed, .purchasing, .deferred:
                                    break // do nothing
                                
                                @unknown default:
                                    print("wtf is that case")
                                }
                            }
                        }
                }
        }
    }
}
