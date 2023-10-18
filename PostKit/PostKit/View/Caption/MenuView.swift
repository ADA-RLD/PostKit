//
//  MenuView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var appstorageManager: AppstorageManager
    @EnvironmentObject var pathManager: PathManager
    @State private var isActive: Bool = false
    @State var menuName = ""
    @State var isCoffeeOpened = true
    @State var isDrinkOpened = false
    @State var isDessertOpened = false
    @State var coffeeSelected: [String] = []
    @State var drinkSelected: [String] = []
    @State var dessertSelected: [String] = []
    
    @ObservedObject var viewModel = ChatGptViewModel.shared

    // TODO: 온보딩 페이지가 완성되면 해당 부분 수정할 예정입니다~
    @State var messages: [Message] = []
    @State var currentInput: String = ""
    
    private let chatGptService = ChatGptService()
    
    var body: some View {
        VStack {
            CustomHeader(action: {pathManager.path.removeLast()}, title: "메뉴 카피 생성")
                .padding(.bottom, paddingHorizontal)
            
            VStack(alignment:.leading) {
                Text("선택한 키워드를 기반으로 카피가 생성됩니다. \n키워드를 선택하지 않을 시 랜덤으로 생성됩니다.")
                    .font(.body2Bold())
                    .foregroundStyle(Color.gray4)
                    .padding(.bottom, 28)
                
                Text("메뉴 이름 *")
                    .foregroundStyle(Color.gray5)
                    .font(.body1Bold())
                    .padding(.bottom, 12)
                CustomTextfield(menuName: $menuName, placeHolder: "아메리카노")
                    .onChange(of: menuName)  {
                        _ in if menuName.count >= 1 {
                            isActive = true
                        } else {
                            isActive = false
                        }
                    }
                    .padding(.bottom, 28)
                
                Text("특징")
                    .foregroundStyle(Color.gray5)
                    .font(.body1Bold())
                    .padding(.bottom, 12)
                
                ScrollView {
                    DisclosureGroup("커피", isExpanded: $isCoffeeOpened) {
                        Keywords(keyName: KeywordsModel().coffeeKeys, selectedIndices: self.$coffeeSelected)
                    }
                    .foregroundStyle(Color.gray5)
                    .font(.body2Bold())
                    .padding(.bottom, 18)
                    
                    Divider()
                        .padding(.bottom, 18)
                    
                    DisclosureGroup("음료") {
                        Keywords(keyName: KeywordsModel().drinkKeys, selectedIndices: self.$drinkSelected)
                    }
                    .foregroundStyle(Color.gray5)
                    .font(.body2Bold())
                    .padding(.bottom, 18)
                    Divider()
                        .padding(.bottom, 18)
                    
                    DisclosureGroup("디저트") {
                        Keywords(keyName: KeywordsModel().dessertKeys, selectedIndices: self.$dessertSelected)
                    }
                    .foregroundStyle(Color.gray5)
                    .font(.body2Bold())
                }
                CtaBtn(btnDescription: "카피 생성", isActive: self.$isActive, action: {
                    if isActive == true {
                        sendMessage()
                        pathManager.path.append(.CaptionResult)
                    }
                })
                .padding(.bottom, 12)
                
            }
            .padding(.horizontal,paddingHorizontal)
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Chat Gpt API에 응답 요청
    func sendMessage(){
        Task{
            var pointText = ""
            self.messages.append(Message(id: UUID(), role: .system, content: "너는 \(appstorageManager.cafeName == "" ? "카페": appstorageManager.cafeName)를 운영하고 있으며 \(appstorageManager.cafeTone == "기본" ? "평범한" : appstorageManager.cafeTone) 말투를 가지고 있어. 글은 존댓말로 작성해줘. 글은 600자 정도로 작성해줘."))
            if !coffeeSelected.isEmpty {
                pointText = pointText + "이 메뉴의 특징으로는 "
                for index in coffeeSelected.indices {
                    pointText = pointText + "\(coffeeSelected[index]), "
                }
                pointText = pointText + "이 있어."
            }
            else if !drinkSelected.isEmpty {
                pointText = pointText + "이 메뉴의 특징으로는 "
                for index in drinkSelected.indices {
                    pointText = pointText + "\(drinkSelected[index]), "
                }
                pointText = pointText + "이 있어."
            }
            else if !dessertSelected.isEmpty {
                pointText = pointText + "이 메뉴의 특징으로는 "
                for index in dessertSelected.indices {
                    pointText = pointText + "\(dessertSelected[index]), "
                }
                pointText = pointText + "이 있어."
            }
            
            self.currentInput = "메뉴의 이름은 \(self.menuName)인 메뉴에 대해서 인스타그램 피드를 작성해줘. \(pointText)"
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
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    MenuView()
}

