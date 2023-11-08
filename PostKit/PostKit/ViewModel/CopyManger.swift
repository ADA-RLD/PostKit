//
//  CopyManger.swift
//  PostKit
//
//  Created by 김다빈 on 11/8/23.
//

import Foundation
import UIKit

class CopyManger {
    static let instance = CopyManger()
    let hapticManager = HapticManager.instance
    
    private init() {}
    // MARK: - 카피 복사
    func copyToClipboard(copyString: String) {
        let hapticManager = HapticManager.instance
        let pasteBoard = UIPasteboard.general
        
        hapticManager.notification(type: .success)
        pasteBoard.string = copyString
    }
}
