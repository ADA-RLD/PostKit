//
//  ErrorViewModel.swift
//  PostKit
//
//  Created by doeun kim on 11/7/23.
//

import Foundation

extension ErrorView {
    func regenerateAnswer() {
        Task{
            let chatGptService = ChatGptService()
            
            var messages: [Message] = []
            
            messages.append(Message(id: UUID(), role: .system, content:viewModel.basicPrompt))
            messages.append(Message(id: UUID(), role: .user, content: viewModel.prompt))
            
            chatGptService.sendMessage(messages: messages)
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
}
