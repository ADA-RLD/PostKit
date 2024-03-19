//
//  GoogleAdmob.swift
//  PostKit
//
//  Created by Kim Andrew on 3/19/24.
//

import Foundation
import SwiftUI
import GoogleMobileAds

enum BannerType {
    case fullSize
    case banner
}

struct FullSizeAd : UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeFullBanner)
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-6026611917778161/1299148880" //광고 ID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.modalPresentationStyle = .fullScreen
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct BannerSizeAd : UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-6026611917778161/7641195954" //광고 ID
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
        FullSizeAd()
    case .banner:
        BannerSizeAd()
            .frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
    }
}
