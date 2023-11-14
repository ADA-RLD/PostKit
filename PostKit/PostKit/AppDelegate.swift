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
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    private let firebaseManager = FirebaseManager()
    private var mixpanelKey: String?
    // 키 오류를 대비해서 랜덤하게 키를 게속 바꿔줍니다.
    func getRandomKey() {
        let chatGptAPIKey = firebaseManager.getDoucument(apiName: "mixpanel") { [weak self] (key) in
            self?.mixpanelKey = key
        }
        print(mixpanelKey ?? "키 값 오류")
    }
    
    
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
      Mixpanel.initialize(token: mixpanelKey ?? "믹스패널 키 오류", trackAutomaticEvents: true)
      Mixpanel.mainInstance().track(event: "앱 실행")
    return true
  }
}
