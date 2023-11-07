//
//  Ex+ATTrackingManager.swift
//  PostKit
//
//  Created by 김다빈 on 11/8/23.
//

import Foundation
import AppTrackingTransparency

extension ATTrackingManager {

    enum AuthorizationStatus : UInt {
        case notDetermined = 0
        case restricted = 1
        case denied = 2
        case authorizaed = 3
      }
}
