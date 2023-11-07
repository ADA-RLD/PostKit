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
                            coinManager.coinUse()
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
    
    // MARK: - 카피 복사
    func copyToClipboard() {
        let hapticManger = HapticManager.instance
        let pasteBoard = UIPasteboard.general
        
        hapticManger.notification(type: .success)
        pasteBoard.string = viewModel.promptAnswer
        self.isShowingToast = true
    }
}