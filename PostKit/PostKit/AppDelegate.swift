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
      Mixpanel.initialize(token: Constants.MixpanelToken, trackAutomaticEvents: true)
      Mixpanel.mainInstance().track(event: "앱 실행")
    return true
  }
}
