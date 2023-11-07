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
    static let minimalCoin: Int = 0
    static let maximalCoin: Int = 10
    static let minmalCaptionCost: Int = 2
    static let minmalHashtagCost: Int = 1
    private var cancellable: AnyCancellable?
    static let shared = CoinManager()
    
    init() {
        // TODO: 출시할때는 24시간으로 바꿔야 할듯여
        cancellable = Timer.publish(every: 170, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                
                self?.coin = 10
            }
    }
    
    func coinUse() {
        coin -= 1
    }
}
