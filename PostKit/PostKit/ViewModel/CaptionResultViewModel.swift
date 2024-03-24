//
//  CaptionResultViewModel.swift
//  PostKit
//
//  Created by doeun kim on 11/7/23.
//

import Foundation
import UIKit

// MARK: 코드의 가독성을 위해 function들을 따로 모았습니다.
extension CaptionResultView {
    // MARK: - 자정 지났을 때 토큰 초기화
    func checkDate() {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy.MM.dd"
        let currentDay = formatterDate.string(from: Date())
        
        if currentDay != coinManager.date {
            coinManager.date = currentDay
            coinManager.coin = CoinManager.maximalCoin
            print("코인이 초기화 되었습니다.")
        }
    }
    
    // MARK: - Chat GPT API에 재생성 요청
    func regenerateAnswer() {
        let apiManager = APIManager()
        if coinManager.checkCoin() {
            pathManager.path.append(.Loading)
            Task {
                loadingModel.isCaptionGenerate = false
                if captionViewModel.isImage() {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        captionViewModel.sendVisionMessage()
                    }
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        captionViewModel.sendMessage()
                    }
                }
            }
        }
    }
}
