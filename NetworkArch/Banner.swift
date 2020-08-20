//
//  Banner.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 20/08/2020.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import UIKit

final private class BannerVC: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        view.adUnitID = adUnitID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        ATTrackingManager.requestTrackingAuthorization { (status) in
            view.load(GADRequest())
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct Banner: View {
    var body: some View {
        HStack {
            BannerVC()
                .frame(width: 320, height: 50, alignment: .center)
        }
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner()
    }
}
