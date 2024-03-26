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



enum AdType {
    case fullSize
    case banner
}

final class InterstitialAdcoordinator: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    
    override init() {
        super.init()
    }
    
    func loadAd(completion: @escaping () -> Void) {
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-6026611917778161/1299148880",
            request: GADRequest(), completionHandler: { [self] ad, error in
                if let error = error {
                    traceLog("Failed to load interstitial ad: \(error.localizedDescription)")
                    return
                }
                traceLog("🟢: FullAd Loading succeeded")
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
                completion()
            })
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
    
    func showAd(from viewController: UIViewController) {
        guard let interstitial = interstitial else {
            traceLog("Ad wasn't ready")
            return
        }
        traceLog(viewController)
        interstitial.present(fromRootViewController: FullSizeAd().viewController)
    }
}


struct FullSizeAd: UIViewControllerRepresentable {
    let viewController = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct BannerSizeAd : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let BannerViewController = UIViewController()
        view.adUnitID = "ca-app-pub-6026611917778161/9828940240" //광고 ID
        view.rootViewController = BannerViewController
        BannerViewController.view.addSubview(view)
        BannerViewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return BannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

@ViewBuilder func GoogleAdMob(type: AdType) -> some View {
    switch type {
    case .fullSize:
        FullSizeAd()
            .frame(width: .zero,height: .zero)
    case .banner:
        HStack{
            Spacer()
            BannerSizeAd()
                .frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
            Spacer()
        }
    }
}
