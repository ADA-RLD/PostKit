//
//  ResultView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI
import CoreData
import UIKit
import Combine

enum ActiveAlert {
    case first, second
}
struct CaptionResultView: View {
    @EnvironmentObject var pathManager: PathManager
    @State private var copyId = UUID()
    @State private var copyResult = "생성된 텍스트가 들어가요."
    @State private var likeCopy = false //좋아요 버튼 결과뷰에서 변경될 수 있으니까 여기 선언
    @State private var isShowingToast = false
    @State private var messages: [Message] = []
    @State private var isPresented: Bool = false
    @State private var activeAlert: ActiveAlert = .first
    @State private var showModal = false
    @State private var cancellables = Set<AnyCancellable>()
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var coinManager = CoinManager.shared
    
    private let pasteBoard = UIPasteboard.general
    private let chatGptService = ChatGptService()
    private let hapticManger = HapticManager.instance
    
    //CoreData Manager
    let coreDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    var body: some View {
        ZStack{
            if viewModel.promptAnswer == "생성된 텍스트가 들어가요." {
                LoadingView()
            }
            else{
                captionResult
                    .onAppear{
                        //Caption이 생성되면 바로 CoreData에 저장
                        //수정을 위해 UUID를 저장
                        copyId = saveCaptionResult(category: viewModel.category, date: convertDayTime(time: Date()), result: viewModel.promptAnswer,like: likeCopy)
                    }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//MARK: 가독성을 위해 View를 분리했습니다.
extension CaptionResultView {
    private var captionResult: some View {
        VStack(alignment:.leading, spacing:0) {
            ContentArea {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Spacer()
                        Button(action: {
                            //TODO: 수정된 CoreData 저장 필요
                            pathManager.path.removeAll()
                            viewModel.promptAnswer = "생성된 텍스트가 들어가요."
                        }, label: {
                            Text("완료")
                                .font(.body1Bold())
                                .foregroundColor(.gray5)
                        })
                    }
                    
                    // MARK: - 타이틀 + 설명
                    VStack(alignment: .leading, spacing: 12) {
                        Text("주문하신 글이 나왔어요!")
                            .font(.title1())
                            .foregroundStyle(Color.gray6)
                    }
                    
                    // MARK: - 생성된 카피 출력 + 복사하기 버튼
                    VStack(alignment: .trailing, spacing: 20) {
                        ZStack(alignment: .leading) {
                            ScrollView(showsIndicators: false){
                                Text(viewModel.promptAnswer)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                    .font(.body1Bold())
                                    .foregroundStyle(Color.gray5)
                            }
                            Spacer()
                            VStack {
                                Spacer()
                                // TODO: historyLeftAction 추가
                                HistoryButton(buttonText: "수정하기", historyRightAction: {
                                    self.showModal = true
                                }, historyLeftAction: {}).sheet(isPresented: self.$showModal, content: {
                                    ResultUpdateModalView(
                                        showModal: $showModal,
                                        stringContent: viewModel.promptAnswer,
                                        resultUpdateType: .captionResult
                                    ) { updatedText in
                                        viewModel.promptAnswer = updatedText
                                    }
                                })
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 400)
                    .background(Color.gray1)
                    .cornerRadius(radius2)
                }
            }
            Spacer()
            
            // MARK: - 재생성 / 복사 버튼
            CustomDoubleBtn(leftBtnLabel: "재생성하기", rightBtnLabel: "복사하기") {
                if coinManager.coin < 5 {
                    activeAlert = .first
                    isPresented.toggle()
                }
                else {
                    activeAlert = .second
                    isPresented.toggle()
                }
            } rightAction: {
                // TODO: 버튼 계속 클릭 시 토스트 사라지지 않는 것 FIX 해야함
                copyToClipboard()
            }
            .toast(isShowing: $isShowingToast)
            .alert(isPresented: $isPresented) {
                switch activeAlert {
                case .first:
                    let cancelBtn = Alert.Button.default(Text("취소")) {
                        
                    }
                    let regenreateBtn = Alert.Button.default(Text("재생성")) {
                        if coinManager.coin > CoinManager.minimalCoin {
                            coinManager.coinUse()
                            regenerateAnswer()
                        }
                    }
                    return Alert(title: Text("1크래딧이 사용됩니다.\n재생성하시겠습니까?\n\n남은 크래딧 \(coinManager.coin)/5"), primaryButton: cancelBtn, secondaryButton: regenreateBtn)
                    
                case .second:
                    return Alert(title: Text("크래딧을 모두 소모하였습니다.\n재생성이 불가능합니다."))
                }
            }
        }
    }
}

// MARK: 코드의 가독성을 위해 function들을 따로 모았습니다.
extension CaptionResultView {
    // MARK: - Chat GPT API에 재생성 요청
    func regenerateAnswer() { /* Daily, Menu를 선택하지 않아도 이전 답변을 참고하여 재생성 합니다.*/
        Task{
            viewModel.promptAnswer = "생성된 텍스트가 들어가요."
            
            var toneInfo = ""
            
            for _tone in storeModel.tone {
                if _tone == "" {
                    break
                }
                
                toneInfo += _tone + ","
            }
            
            if toneInfo == "" {
                toneInfo = "평범"
            }
            
            self.messages.append(Message(id: UUID(), role: .system, content:viewModel.basicPrompt))
            let newMessage = Message(id: UUID(), role: .user, content: viewModel.prompt)
            self.messages.append(newMessage)

            chatGptService.sendMessage(messages: self.messages)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            // TODO: - 오류 코드를 기반으로 오류 처리 진행 필요
                            print("error 발생. error code: \(error._code)")
                        case .finished:
                            print("Caption 생성이 무사히 완료되었습니다.")
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
    
    // MARK: - 카피 복사
    func copyToClipboard() {
        hapticManger.notification(type: .success)
        pasteBoard.string = viewModel.promptAnswer
        isShowingToast = true
    }
}

// MARK: - 기존 뷰 위에 토스트를 위로 올려줌
struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let duration: TimeInterval
    func body(content: Content) -> some View {
        ZStack{
            content
            if isShowing{
                VStack{
                    Spacer()
                    Text("클립보드에 복사되었습니다!")
                        .font(.body1Bold())
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .background(.black.opacity(0.6))
                        .cornerRadius(radius1)
                        .padding(.horizontal, paddingHorizontal)
                        .padding(.bottom, 20)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()+duration){
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 토스트를 띄워주는 모디파이어 적용
extension View {
    func toast(isShowing: Binding<Bool>, duration: TimeInterval = 1.5) -> some View {
        modifier(ToastModifier(isShowing: isShowing, duration: duration))
    }
}

extension CaptionResultView : CaptionResultProtocol {
    func convertDayTime(time: Date) -> Date {
        let today = Date()
        let timezone = TimeZone.autoupdatingCurrent
        let secondsFromGMT = timezone.secondsFromGMT(for: today)
        let localizedDate = today.addingTimeInterval(TimeInterval(secondsFromGMT))
        return localizedDate
    }
    
    func saveCaptionResult(category: String, date: Date, result: String, like: Bool) -> UUID {
        let newCaption = CaptionResult(context: coreDataManager.context)
        newCaption.resultId = UUID()
        newCaption.date = date
        newCaption.category = category
        newCaption.caption = result
        newCaption.like = false
        coreDataManager.save()
        print("Caption 저장 완료!\n resultId : \(newCaption.resultId)\n Date : \(newCaption.date)\n Category : \(newCaption.category)\n Caption : \(newCaption.caption)")
        
        return newCaption.resultId ?? UUID()
    }
    
    func initCaptionResult(Result: String) {
        //        Result = "생성된 텍스트가 들어가요."
    }
}

//
//#Preview {
//    CaptionResultView
//}
