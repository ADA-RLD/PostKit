//
//  ErrorViewModel.swift
//  PostKit
//
//  Created by doeun kim on 11/7/23.
//

import Foundation

extension ErrorView {
    // TODO: Image 캡션글 생성일때와 키워드기반의 생성글일떄를 분리해서 regenerateAnswer를 해야한다.
    func regenerateAnswer() {
        let apiManager = APIManager()
        if viewModel.imageURL != "" {
            Task {
                apiManager.sendImageKeyWord(basicPrompt:viewModel.basicPrompt, prompt:viewModel.prompt,imageURL: viewModel.imageURL)
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
                            guard let textResponse = response.captionResult else{return}
                            viewModel.promptAnswer = textResponse
                        }
                    )
                    .store(in: &cancellables)
            }
        }
        else {
            Task {
                apiManager.sendKeyWord(basicPrompt: viewModel.basicPrompt,prompt:viewModel.prompt)
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
                            guard let textResponse = response.captionResult else{return}
                            viewModel.promptAnswer = textResponse
                        }
                    )
                    .store(in: &cancellables)
            }
        }
    }
}
