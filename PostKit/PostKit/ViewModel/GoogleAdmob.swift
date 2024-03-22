//
//  GoogleAdmob.swift
//  PostKit
//
//  Created by Kim Andrew on 3/19/24.
//

import Foundation
import SwiftUI
import UIKit
import GoogleMobileAds

enum BannerType {
    case fullSize
    case banner
}

class InterstitialAdcoordinator: NSObject, GADFullScreenContentDelegate {
    var interstitial: GADInterstitialAd?
    
    func loadAd() {
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
            request: request) { ad, error in
                if let error = error {
                    traceLog("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                self.interstitial = ad
                self.interstitial?.fullScreenContentDelegate = self
            }
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        traceLog("Ad did fail to present full screen content.")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        traceLog("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        traceLog("Ad did dismiss full screen content.")
        interstitial = nil
    }
    
    func showAd(from viewController: UIViewController?) {
        guard let viewController = viewController, let interstitial = interstitial else {
            traceLog("Ad wasn't ready")
            return
        }
        interstitial.present(fromRootViewController: viewController)
    }
}


struct FullSizeAd: UIViewControllerRepresentable {
    var interstitial: GADInterstitialAd?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct BannerSizeAd : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" //광고 ID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

@ViewBuilder func GoogleAdMob(type: BannerType) -> some View {
    switch type {
    case .fullSize:
        FullSizeAd(interstitial: InterstitialAdcoordinator().interstitial)
    case .banner:
        HStack{
            Spacer()
            BannerSizeAd()
                .frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
            Spacer()
        }
    }
}
