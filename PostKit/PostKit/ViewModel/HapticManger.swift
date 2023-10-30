//
//  HapticManger.swift
//  PostKit
//
//  Created by 김다빈 on 10/30/23.
//

import SwiftUI

class HapticManager {
    static let instance = HapticManager()
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
