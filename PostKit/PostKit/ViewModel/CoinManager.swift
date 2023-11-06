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
    @AppStorage("coin") var coin: Int = 5
    static let minimalCoin: Int = 0
    private var cancellable: AnyCancellable?
    static let shared = CoinManager()
    
    init() {
        // TODO: 출시할때는 24시간으로 바꿔야 할듯여
        cancellable = Timer.publish(every: 5, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                
                self?.coin = 5
            }
    }
    
    func coinUse() {
        coin -= 1
    }
}
