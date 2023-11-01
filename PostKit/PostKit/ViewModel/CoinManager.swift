//
//  CoinManger.swift
//  PostKit
//
//  Created by 김다빈 on 11/1/23.
//

import Foundation
import Combine
import SwiftUI

class CoinManager: ObservableObject {
    @AppStorage("coin") var coin: Int = 0
    private var cancellable: AnyCancellable?
    static let shared = CoinManager()
    
    init() {
        cancellable = Timer.publish(every: 170, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                
                self?.coin = 0
            }
    }
    
    func coinUse() {
        coin += 1
    }
}
