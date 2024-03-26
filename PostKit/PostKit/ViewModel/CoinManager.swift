//
//  CoinManager.swift
//  PostKit
//
//  Created by 김다빈 on 11/1/23.
//

import Foundation
import Combine
import SwiftUI

class CoinManager: ObservableObject {
    @AppStorage("_coin") var coin: Int = 10
    @AppStorage("_date") var date: String = "0000.00.00"
    
    static let minimalCoin: Int = 0
    static let maximalCoin: Int = 10
    static let captionCost: Int = 2
    static let hashtagCost: Int = 1
    private var cancellable: AnyCancellable?
    static let shared = CoinManager()
    
    func coinCaptionUse() {
        coin -= 2
    }
    
    func coinHashtagUse() {
        coin -= 1
    }
}
