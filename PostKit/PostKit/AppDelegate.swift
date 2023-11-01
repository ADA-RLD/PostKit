//
//  AppDelegate.swift
//  PostKit
//
//  Created by 김다빈 on 11/1/23.
//
import Mixpanel
import Foundation
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    // ...
      Mixpanel.initialize(token: Constants.MixpanelToken, trackAutomaticEvents: true)
      Mixpanel.mainInstance().track(event: "Signed Up", properties: [
        "Signup Type" : "Referral",
      ])
    return true
  }
}
