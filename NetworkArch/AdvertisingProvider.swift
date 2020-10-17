//
//  AdvertisingProvider.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 17/10/2020.
//

import Foundation
import SwiftUI
import Combine
import Appodeal
import StackConsentManager

#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif

typealias CompletionHandler = (_ success:Bool) -> Void

/// Advertising interface that provides published state
/// which can be used in SwiftUI
final class AdvertisingProvider: NSObject, ObservableObject {
    // MARK: Types and definitions
    private typealias SynchroniseConsentCompletion = () -> Void
    
    /// Constants
    private struct AppodealConstants {
        static let key: String = Constants.AppoDealAPIKey
        static let adTypes: AppodealAdType = [.interstitial, .rewardedVideo, .banner, .nativeAd]
        static let logLevel: APDLogLevel = .debug
        static let testMode: Bool = false
        static let placement: String = "default"
    }
    
    /// APDBannerView SwiftUI interface
    struct Banner: UIViewRepresentable {
        typealias UIViewType = APDBannerView
        
        func makeUIView(context: UIViewRepresentableContext<Banner>) -> APDBannerView {
            // Use shared banner view to
            return AdvertisingProvider.shared.bannerView
        }
        
        func updateUIView(_ uiView: APDBannerView, context: UIViewRepresentableContext<Banner>) {
            uiView.rootViewController = UIApplication.shared.rootViewController
        }
    }
    
    // MARK: Stored properties
    /// Singleton object of provider
    static let shared: AdvertisingProvider = AdvertisingProvider()
    
    private var synchroniseConsentCompletion: SynchroniseConsentCompletion?
    
    let bannerHeight: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? kAPDAdSize728x90.height : kAPDAdSize320x50.height
    }()
    
    fileprivate lazy var bannerView: APDBannerView = {
        // Select banner ad size by current interface idiom
        let adSize = UIDevice.current.userInterfaceIdiom == .pad ?
            kAPDAdSize728x90 :
            kAPDAdSize320x50
        
        let banner = APDBannerView(
            size:  adSize,
            rootViewController: UIApplication.shared.rootViewController ?? UIViewController()
        )
        // Set banner initial frame
        banner.frame = CGRect(
            x: 0,
            y: 0,
            width: adSize.width,
            height: adSize.height
        )
        
        banner.delegate = self
        
        return banner
    }()
    
    // MARK: Published properties
    @Published var isAdInitialised     = false
    @Published var isBannerReady       = false
    @Published var isInterstitialReady = false
    @Published var isRewardedReady     = false
    
    // MARK: Public methods
    func initialize() {
        // Check user consent beforestak advertising
        // initialisation
        requestTrackingAuthorization { [weak self] in
            self?.synchroniseConsent { [weak self] in
                self?.initializeAppodeaSDK()
            }
        }
    }
    
    private func requestTrackingAuthorization(completion: @escaping () -> Void) {
        #if canImport(AppTrackingTransparency)
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                completion()
            }
        } else {
            completion()
        }
        #else
        completion()
        #endif
    }
    
    func presentInterstitial() {
        defer { isInterstitialReady = false }
        // Check availability of interstial
        guard
            Appodeal.canShow(.interstitial, forPlacement: AppodealConstants.placement),
            let viewController = UIApplication.shared.rootViewController
        else { return }
        Appodeal.showAd(.interstitial,
                        forPlacement: AppodealConstants.placement,
                        rootViewController: viewController)
    }
    
    func presentRewarded(completionHandler: CompletionHandler) {
        defer { isRewardedReady = false }
        // Check availability of rewarded video
        guard
            Appodeal.canShow(.rewardedVideo, forPlacement: AppodealConstants.placement),
            let viewController = UIApplication.shared.rootViewController
        else { return }
        Appodeal.showAd(.rewardedVideo,
                        forPlacement: AppodealConstants.placement,
                        rootViewController: viewController)
        
        let flag = true

        completionHandler(flag)
    }
    
    // MARK: Private methods
    private func initializeAppodeaSDK() {
        /// Custom settings
        // Appodeal.setFramework(.native, version: "1.0.0")
        // Appodeal.setTriggerPrecacheCallbacks(true)
        // Appodeal.setLocationTracking(true)
        
        /// Test Mode
        Appodeal.setTestingEnabled(AppodealConstants.testMode)
        
        /// User Data
        // Appodeal.setUserId("userID")
        // Appodeal.setUserAge(25)
        // Appodeal.setUserGender(.male)
        Appodeal.setLogLevel(AppodealConstants.logLevel)
        // Disable autocache for banner and native ad
        // we will cache it manually
        Appodeal.setAutocache(false, types: [.banner, .nativeAd])
        // Set delegates
        Appodeal.setInterstitialDelegate(self)
        Appodeal.setRewardedVideoDelegate(self)
        
        // Initialise Appodeal SDK with consent report
        if let consent = STKConsentManager.shared().consent {
            Appodeal.initialize(
                withApiKey: Constants.AppoDealAPIKey,
                types: AppodealConstants.adTypes,
                hasConsent: consent as! Bool
            )
        } else {
            Appodeal.initialize(
                withApiKey: Constants.AppoDealAPIKey,
                types: AppodealConstants.adTypes
            )
        }
        
        // Trigger banner cache
        // It can be done after any moment after Appodeal initialisation
        bannerView.loadAd()
        
        self.isAdInitialised = true
    }
    
    private func synchroniseConsent(completion: SynchroniseConsentCompletion?) {
        STKConsentManager.shared().synchronize(withAppKey: AppodealConstants.key) { error in
            error.map { print("Error while synchronising consent manager: \($0)") }
            guard STKConsentManager.shared().shouldShowConsentDialog == .true else {
                completion?()
                return
            }
            
            STKConsentManager.shared().loadConsentDialog { [weak self] error in
                error.map { print("Error while loading consent dialog: \($0)") }
                guard let controller = UIApplication.shared.rootViewController,
                      STKConsentManager.shared().isConsentDialogReady
                else {
                    completion?()
                    return
                }
                
                self?.synchroniseConsentCompletion = completion
                STKConsentManager.shared().showConsentDialog(
                    fromRootViewController: controller,
                    delegate: self
                )
            }
        }
    }
}

// MARK: Protocols implementations
extension AdvertisingProvider: APDBannerViewDelegate {
    func bannerViewDidLoadAd(_ bannerView: APDBannerView,
                             isPrecache precache: Bool) {
        isBannerReady = true
    }
    
    func bannerView(_ bannerView: APDBannerView,
                    didFailToLoadAdWithError error: Error) {
        isBannerReady = false
    }
}


extension AdvertisingProvider: AppodealInterstitialDelegate {
    func interstitialDidLoadAdIsPrecache(_ precache: Bool) {
        isInterstitialReady = true
    }
    
    func interstitialDidFailToLoadAd() {
        isInterstitialReady = false
    }
    
    func interstitialDidExpired() {
        isInterstitialReady = false
    }
}


extension AdvertisingProvider: AppodealRewardedVideoDelegate {
    func rewardedVideoDidLoadAdIsPrecache(_ precache: Bool) {
        isRewardedReady = true
    }
    
    func rewardedVideoDidFailToLoadAd() {
        isRewardedReady = false
    }
    
    func rewardedVideoDidExpired() {
        isRewardedReady = false
    }
}


extension AdvertisingProvider: STKConsentManagerDisplayDelegate {
    func consentManager(_ consentManager: STKConsentManager, didFailToPresent error: Error) {
        synchroniseConsentCompletion?()
    }
    
    func consentManagerDidDismissDialog(_ consentManager: STKConsentManager) {
        synchroniseConsentCompletion?()
    }
    
    // No-op
    func consentManagerWillShowDialog(_ consentManager: STKConsentManager) {}
}
