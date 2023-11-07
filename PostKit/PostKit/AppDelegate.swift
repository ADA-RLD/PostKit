//
//  AppDelegate.swift
//  PostKit
//
//  Created by 김다빈 on 11/1/23.
//
import Mixpanel
import Foundation
import UIKit
import AppTrackingTransparency
import AdSupport

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    return true
  }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        requestTrackingAuthorization()
    }
    
    private func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                // 추적 권한이 허용된 경우
                Mixpanel.initialize(token: Constants.MixpanelToken, trackAutomaticEvents: true)
                Mixpanel.mainInstance().track(event: "Signed Up", properties: [
                  "Signup Type" : "Referral",
                ])
            case .denied, .restricted, .notDetermined:
                // 추적 권한이 거부되거나 제한된 경우, 또는 아직 결정되지 않은 경우
                Mixpanel.initialize(token: Constants.MixpanelToken, trackAutomaticEvents: false, optOutTrackingByDefault: false)
            @unknown default:
                break
            }
        }
    }
}
