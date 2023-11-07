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
    
    @State private var cancellables = Set<AnyCancellable>()
    @State private var messages: [Message] = []
    
    private let chatGptService = ChatGptService()
    
    var errorCasue: String
    var errorDescription: String
    var errorImage: ImageResource
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Image(errorImage)
            
            VStack(alignment: .center, spacing: 12) {
                Text(errorCasue)
                    .title1(textColor: .gray6)
                    .multilineTextAlignment(.center)
                
                Text(errorDescription)
                    .body2Bold(textColor: .gray4)
                    .multilineTextAlignment(.center)
            }
            
            AlertCustomDoubleBtn(topBtnLabel: "재생성",
                                 bottomBtnLabel: "홈으로",
                                 topAction: {// TODO: extension으로 추후 리팩토링 진행하기
                pathManager.path.append(.Loading)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                    Task{
                        self.messages.append(Message(id: UUID(), role: .system, content:viewModel.basicPrompt))
                        let newMessage = Message(id: UUID(), role: .user, content: viewModel.prompt)
                        self.messages.append(newMessage)
                                            
                        chatGptService.sendMessage(messages: self.messages)
                            .sink(
                                receiveCompletion: { completion in
                                    switch completion {
                                    case .failure(let error):
                                        print("error 발생. error code: \(error._code)")
                                        if error._code == 10 {
                                            pathManager.path.append(.ErrorResultFailed)
                                        }
                                        else if error._code == 13 {
                                            pathManager.path.append(.ErrorNetwork)
                                        }
                                    case .finished:
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
                }
            },
                                 bottomAction: {pathManager.path.removeAll()})
            
            
        }
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
//    ErrorView(errorCasue: "네트워크 연결이\n원활하지 않아요", errorDescription: "네트워크 연결을 확인해주세요", imageResource: .errorNetwork)
    ErrorView(errorCasue: "생성을\n실패했어요", errorDescription: "예기치 못한 이유로 생성에 실패했어요\n 다시 시도해주세요", errorImage: .errorFailed)
}
