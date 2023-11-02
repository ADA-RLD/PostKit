//
//  DailyView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/13.
//

import SwiftUI
import CoreData

struct DailyView: View {
    @EnvironmentObject var pathManager: PathManager
    @State private var isActive: Bool = false
    @State var weatherSelected: [String] = []
    @State var dailyCoffeeSelected: [String] = []
    @State var dailyDessertSelected: [String] = []
    @State private var isContentsOpened = [false, false, false]
    @State private var isPresented: Bool = false
    
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = ChatGptViewModel.shared
    
    //CoreData Manager
    let storeDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    // TODO: 온보딩 페이지가 완성되면 해당 부분 수정할 예정입니다~
    @State var messages: [Message] = []
    @State var currentInput: String = ""
    private let chatGptService = ChatGptService()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomHeader(action: {pathManager.path.removeLast()}, title: "일상 카피 생성")
            ScrollView {
                ContentArea {
                    VStack(alignment: .leading, spacing: 28) {
                        Text("선택한 키워드를 기반으로 카피가 생성됩니다. \n키워드를 선택하지 않을 시 랜덤으로 생성됩니다.")
                            .font(.body2Bold())
                            .foregroundStyle(Color.gray4)
                        
                        
                        
                        VStack(alignment:.leading, spacing: 24) {
                            
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("날씨 / 계절")
                                    .foregroundStyle(Color.gray5)
                                    .font(.body1Bold())
                                Keywords(keyName: KeywordsModel().weatherKeys , selectedIndices: self.$weatherSelected)
                                    .frame(height: isContentsOpened[0] ? 180 : 80)
                                
                                if !isContentsOpened[0] {
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            isContentsOpened[0].toggle()
                                        }
                                    }, label: {
                                        Text("더보기")
                                            .font(.body2Regular())
                                            .foregroundStyle(.gray4)
                                            .underline()
                                    })
                                }
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("커피 / 음료")
                                    .foregroundStyle(Color.gray5)
                                    .font(.body1Bold())
                                
                                Keywords(keyName: KeywordsModel().dailyCoffeeKeys, selectedIndices: self.$dailyCoffeeSelected)
                                    .frame(height: isContentsOpened[1] ? 180 : 80)
                                
                                if !isContentsOpened[1] {
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            isContentsOpened[1].toggle()
                                        }
                                    }, label: {
                                        Text("더보기")
                                            .font(.body2Regular())
                                            .foregroundStyle(.gray4)
                                            .underline()
                                    })
                                }
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("디저트")
                                    .foregroundStyle(Color.gray5)
                                    .font(.body1Bold())
                                
                                Keywords(keyName: KeywordsModel().dailyDessertKeys, selectedIndices: self.$dailyDessertSelected)
                                    .frame(height: isContentsOpened[2] ? 140 : 80)
                                
                                
                                if !isContentsOpened[2] {
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            isContentsOpened[2].toggle()
                                        }
                                    }, label: {
                                        Text("더보기")
                                            .font(.body2Regular())
                                            .foregroundStyle(.gray4)
                                            .underline()
                                        
                                    })
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
                .scrollIndicators(.hidden)
            }
        }
        
        CTABtn(btnLabel: "카피 생성", isActive: .constant(true), action: {
            if coinManager.coin < 5 {
                sendMessage()
                pathManager.path.append(.CaptionResult)
                coinManager.coinUse()
                print(coinManager.coin)
            }
            else {
                isPresented.toggle()
            }
        })
        .alert(isPresented: $isPresented, content: {
            return Alert(title: Text("크래딧을 모두 소모하였습니다. 재생성이 불가능합니다."))
        })
        .navigationBarBackButtonHidden()
        
    }
    
}



//MARK: extension Function
extension DailyView {
    // MARK: - Chat Gpt API에 응답 요청
    func sendMessage() {
        Task{
            createPrompt()
            self.messages.append(Message(id: UUID(), role: .user, content: self.currentInput))
            await createCaption()
        }
    }
    
    func createPrompt(){
        var pointText = ""
        
        print("생성 정보 :\nStore Name : \(storeModel.storeName)\nTone : \(storeModel.tone)")
        // TODO: COREDATA 변경필요
        if storeModel.tone.contains("기본") {
            self.messages.append(Message(id: UUID(), role: .system, content: "너는 \(storeModel.storeName == "" ? "카페": storeModel.storeName)를 운영하고 있으며 평범한 말투를 가지고 있어. 글은 존댓말로 작성해줘. 꼭 글자수는 150자 정도로 작성해줘."))
        }
        else{
            self.messages.append(Message(id: UUID(), role: .system, content: "너는 \(storeModel.storeName == "" ? "카페": storeModel.storeName)"))

              for _tone in storeModel.tone {
                  self.messages.append(Message(id: UUID(), role: .system, content: "\(_tone == "기본" ? "평범한": _tone)"))
              }
            
            self.messages.append(Message(id: UUID(), role: .system, content:"말투를 가지고 있어. 글은 존댓말로 작성해줘. 꼭 글자수는 150자 정도로 작성해줘."))
        }
        
        if !weatherSelected.isEmpty {
            pointText = pointText + "오늘 날씨의 특징으로는 "
            for index in weatherSelected.indices {
                pointText = pointText + "\(weatherSelected[index]), "
            }
            pointText = pointText + "이 있어."
        }
        
        if !dailyCoffeeSelected.isEmpty {
            pointText = pointText + "오늘 이야기하고자 하는 음료는 "
            for index in dailyCoffeeSelected.indices {
                pointText = pointText + "\(dailyCoffeeSelected[index]), "
            }
            pointText = pointText + "이 있어."
        }
        
        if !dailyDessertSelected.isEmpty {
            pointText = pointText + "오늘 이야기하고자 하는 디저트는 "
            for index in dailyDessertSelected.indices {
                pointText = pointText + "\(dailyDessertSelected[index]), "
            }
            pointText = pointText + "이 있어."
        }
        
        self.currentInput = "카페 일상과 관련된 인스타그램 피드를 작성해줘. \(pointText)"
    }
    
    func createCaption() async{
        viewModel.prompt = self.currentInput
        self.currentInput = ""
        let response = await chatGptService.sendMessage(messages: self.messages)
        viewModel.promptAnswer = response?.choices.first?.message.content == nil ? "" : response!.choices.first!.message.content
        viewModel.category = "일상"
        print(response?.choices.first?.message.content as Any)
        print(response as Any)
    }
}

//#Preview {
//    DailyView()
//}

