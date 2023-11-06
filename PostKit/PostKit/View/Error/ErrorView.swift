//
//  ErrorView.swift
//  PostKit
//
//  Created by 김다빈 on 10/28/23.
//

import SwiftUI
import Combine

struct ErrorView: View {
    
    @EnvironmentObject var pathManager: PathManager
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var loadingModel = LoadingViewModel.shared
    
    @State private var cancellables = Set<AnyCancellable>()
    @State private var messages: [Message] = []
    
    private let chatGptService = ChatGptService()
    
    var errorCasue: String
    var errorDescription: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            
            VStack(alignment: .center, spacing: 24) {
                
                Text(errorCasue)
                    .font(.title1())
                    .foregroundColor(.gray6)
                
                Text(errorDescription)
                    .font(.body2Bold())
                    .foregroundColor(.gray4)
                
            }
            
            VStack(alignment: .center, spacing: 16) {
                errorBtn(action: {
                    pathManager.path.removeAll()
                }, btnAction: "홈으로", btnColor: Color.gray2, btnTextColor: Color.gray5)
                
                errorBtn(action: {
                    Task{
                        self.messages.append(Message(id: UUID(), role: .system, content:viewModel.basicPrompt))
                        let newMessage = Message(id: UUID(), role: .user, content: viewModel.prompt)
                        self.messages.append(newMessage)
                        
                        pathManager.path.append(.Loading)

                        chatGptService.sendMessage(messages: self.messages)
                            .sink(
                                receiveCompletion: { completion in
                                    switch completion {
                                    case .failure(let error):
                                        loadingModel.isCaptionGenerate = true
                                        print("error 발생. error code: \(error._code)")
                                        if error._code == 10 {
                                            pathManager.path.append(.ErrorResultFailed)
                                        }
                                        else if error._code == 13 {
                                            pathManager.path.append(.ErrorNetwork)
                                        }
                                    case .finished:
                                        loadingModel.isCaptionGenerate = false
                                        print("Caption 생성이 무사히 완료되었습니다.")
                                        coinManager.coinUse()
                                        pathManager.path.append(.CaptionResult)
                                    }
                                },
                                receiveValue:  { response in
                                    print("response: \(response)")
                                    guard let textResponse = response.choices.first?.message.content else {return}
                                    
                                    viewModel.promptAnswer = textResponse
                                }
                            )
                            .store(in: &cancellables)
                    }
                }, btnAction: "재생성", btnColor: .main, btnTextColor: .white)
                
            }
        }
        .padding(.horizontal,106)
        .navigationBarBackButtonHidden()
    }
}

// MARK: extension Views
private func errorBtn(action: @escaping () -> Void, btnAction: String, btnColor: Color, btnTextColor: Color ) -> some View {
    Button {
        action()
    } label: {
        RoundedRectangle(cornerRadius: radius1)
            .frame(height: 56)
            .overlay(alignment: .center) {
                Text(btnAction)
                    .font(.body1Bold())
                    .foregroundColor(btnTextColor)
            }
            .foregroundColor(btnColor)
    }

    
}

#Preview {
    ErrorView(errorCasue: "결과 생성 실패", errorDescription: "결과 생성에 실패했어요 ㅠ-ㅠ")
}
