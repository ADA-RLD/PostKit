//
//  ResultView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI
import CoreData
import UIKit

struct CaptionResultView: View {
    //@EnvironmentObject var appstorageManager: AppstorageManager
    @EnvironmentObject var pathManager: PathManager
    @State private var copyResult = "생성된 텍스트가 들어가요."
    @State private var isShowingToast = false
    private let pasteBoard = UIPasteboard.general
    @State var messages: [Message] = []
    @ObservedObject var viewModel = ChatGptViewModel.shared
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
                        saveCaptionResult(category: viewModel.category, date: convertDayTime(time: Date()), Result: viewModel.promptAnswer)
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
                    // MARK: - 타이틀 + 설명
                    VStack(alignment: .leading, spacing: 12) {
                        Text("주문하신 카피가 나왔어요!")
                            .font(.title1())
                            .foregroundStyle(Color.gray6)
                        Text("생성된 피드가 마음에 들지 않는다면\n다시 생성하기 버튼을 통해 새로운 피드를 생성해 보세요.")
                            .font(.body2Bold())
                            .foregroundStyle(Color.gray4)
                    }
                    
                    // MARK: - 생성된 카피 출력 + 복사하기 버튼
                    VStack(alignment: .trailing, spacing: 20) {
                        VStack(alignment: .leading) {
                            ScrollView(showsIndicators: false){
                                Text(viewModel.promptAnswer)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                    .font(.body1Bold())
                                    .foregroundStyle(Color.gray5)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 400)
                        .background(Color.gray1)
                        .cornerRadius(radius2)
                        
                        Button {
                            copyToClipboard()
                            // TODO: 버튼 계속 클릭 시 토스트 사라지지 않는 것 FIX 해야함
                        } label: {
                            HStack(spacing: 4.0) {
                                Image(systemName: "doc.on.doc")
                                Text("복사하기")
                            }
                            .foregroundStyle(Color.main)
                            .font(.body1Bold())
                            .disabled(isShowingToast)
                        }
                    }
                }
            }
            Spacer()
            
            // MARK: - 완료 / 재생성 버튼
            CustomDoubleeBtn(leftBtnLabel: "완료", rightBtnLabel: "재생성") {
                pathManager.path.removeAll()
            } rightAction: {
                regenerateAnswer()
            }
            
        }
        .toast(isShowing: $isShowingToast)
    }

}

// MARK: 코드의 가독성을 위해 function들을 따로 모았습니다.
extension CaptionResultView {
    // MARK: - Chat GPT API에 재생성 요청
    func regenerateAnswer() { /* Daily, Menu를 선택하지 않아도 이전 답변을 참고하여 재생성 합니다.*/
        Task{
            viewModel.promptAnswer = "생성된 텍스트가 들어가요."
            //TODO: COREDATA 변경 필요
//            self.messages.append(Message(id: UUID(), role: .assistant, content: "너는 \(storeModel.storeName == "" ? "카페": storeModel.storeName)를 운영하고 있으며 \(storeModel.tone == "기본" ? "평범한" : storeModel.tone) 말투를 가지고 있어. 글은 존댓말로 작성해줘. 글은 150자 정도로 작성해줘."))
            let newMessage = Message(id: UUID(), role: .user, content: viewModel.prompt)
            self.messages.append(newMessage)
            let response = await chatGptService.sendMessage(messages: self.messages)
            print(response as Any)
            viewModel.promptAnswer = response?.choices.first?.message.content == nil ? "" : response!.choices.first!.message.content
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
    
    func saveCaptionResult(category: String, date: Date, Result: String) {
        let newCaption = CaptionResult(context: coreDataManager.context)
        newCaption.resultId = UUID()
        newCaption.date = date
        newCaption.category = category
        newCaption.caption = Result
        coreDataManager.save()
        print("Caption 저장 완료!\n resultId : \(newCaption.resultId)\n Date : \(newCaption.date)\n Category : \(newCaption.category)\n Caption : \(newCaption.caption)")
    }
    
    func fetchCaptionResult(category: String) {
        print("Fetch 불필요")
    }
    
}

//#Preview {
//    CaptionResultView()
//}
