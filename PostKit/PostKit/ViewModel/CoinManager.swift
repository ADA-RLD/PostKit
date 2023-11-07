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
    @AppStorage("coin") var coin: Int = 10
    @AppStorage("date") var date: String = "0000.00.00"
    
    static let minimalCoin: Int = 0
    static let maximalCoin: Int = 10
    private var cancellable: AnyCancellable?
    static let shared = CoinManager()
    
    init() {
        coin = 10
    }
    
    func coinCaptionUse() {
        coin -= 2
    }
    
    func coinHashtagUse() {
        coin -= 1
    }
}
