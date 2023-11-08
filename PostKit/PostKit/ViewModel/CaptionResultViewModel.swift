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
    func regenerateAnswer() { /* Daily, Menu를 선택하지 않아도 이전 답변을 참고하여 재생성 합니다.*/
        let chatGptService = ChatGptService()
        
        Task{
            self.messages.append(Message(id: UUID(), role: .system, content:viewModel.basicPrompt))
            self.messages.append(Message(id: UUID(), role: .user, content: viewModel.prompt))
            
            chatGptService.sendMessage(messages: self.messages)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            if error._code == 10 {
                                pathManager.path.append(.ErrorResultFailed)
                            }
                            else if error._code == 13 {
                                pathManager.path.append(.ErrorNetwork)
                            }
                        case .finished:
                            coinManager.coinCaptionUse()
                            pathManager.path.append(.CaptionResult)
                        }
                    },
                    receiveValue:  { response in
                        guard let textResponse = response.choices.first?.message.content else {return}
                        viewModel.promptAnswer = textResponse
                    }
                )
                .store(in: &cancellables)
        }
    }
}
