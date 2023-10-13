//
//  DailyView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/13.
//
//이게 찐
import SwiftUI

struct DailyView: View {
    @EnvironmentObject var pathManager: PathManager
    @State private var isActive: Bool = false
    @State var weatherSelected: [String] = []
    @State var dailyCoffeeSelected: [String] = []
    @State var dailyDessertSelected: [String] = []
    @State private var isWeatherOpened = false
    
    @ObservedObject var viewModel = ChatGptViewModel.shared
    // TODO: 온보딩 페이지가 완성되면 해당 부분 수정할 예정입니다~
    @State var messages: [Message] = [Message(id: UUID(), role: .system, content: "너는 루시드 드림 카페를 운영하고 있으며 친근한 말투를 가지고 있어. 글은 존댓말로 작성해줘. 글은 600자 정도로 작성해줘.")]
    @State var currentInput: String = ""
    private let chatGptService = ChatGptService()
    
    var body: some View {
        VStack(alignment:.leading) {
            CustomHeader(action: {pathManager.path.removeLast()}, title: "일상 카피 생성")
                .padding(.bottom, paddingHorizontal)
            
            Text("선택한 키워드를 기반으로 카피가 생성됩니다. \n키워드를 선택하지 않을 시 랜덤으로 생성됩니다.")
                .font(.body2Bold())
                .foregroundStyle(Color.gray4)
                .padding(.bottom, 28)
            
            ScrollView {
                VStack(alignment: .leading) {
            Text("날씨 / 계절")
                .foregroundStyle(Color.gray5)
                .font(.body1Bold())
                .padding(.bottom, 12)
            
                Keywords(keyName: KeywordsModel().weatherKeys, selectedIndices: self.$weatherSelected)
                
                Divider()
                    .padding(.bottom, 18)
                
                Text("커피 / 음료")
                    .foregroundStyle(Color.gray5)
                    .font(.body1Bold())
                    .padding(.bottom, 12)
                
                Keywords(keyName: KeywordsModel().dailyCoffeeKeys, selectedIndices: self.$dailyCoffeeSelected)
                    
                    Divider()
                        .padding(.bottom, 18)
                Text("디저트")
                    .foregroundStyle(Color.gray5)
                    .font(.body1Bold())
                    .padding(.bottom, 12)
                
                Keywords(keyName: KeywordsModel().dailyDessertKeys, selectedIndices: self.$dailyDessertSelected)
                    
                    Divider()
                        .padding(.bottom, 18)
            }
        }
            CustomBtn(btnDescription: "카피생성", isActive: self.$isActive, action: {
                sendMessage()
                pathManager.path.append(.Result)
            })
            .padding(.bottom, 12)
            
            
        }
        .padding(.horizontal,paddingHorizontal)
    }
    
    // MARK: - Chat Gpt API에 응답 요청
    func sendMessage(){
        Task{
            var pointText = ""
            
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
            let newMessage = Message(id: UUID(), role: .user, content: self.currentInput)
            self.messages.append(newMessage)
            viewModel.prompt = self.currentInput
            self.currentInput = ""
            let response = await chatGptService.sendMessage(messages: self.messages)
            viewModel.promptAnswer = response?.choices.first?.message.content == nil ? "" : response!.choices.first!.message.content
            print(response?.choices.first?.message.content as Any)
            print(response as Any)
        }
    }
}

#Preview {
    DailyView()
}

