//
//  MenuView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI
import CoreData
import Combine

struct MenuView: View {
    //@EnvironmentObject var appstorageManager: AppstorageManager
    @EnvironmentObject var pathManager: PathManager
    @State private var isActive: Bool = false
    @State private var menuName = ""
    @State private var isCoffeeOpened = true
    @State private var isDrinkOpened = false
    @State private var isDessertOpened = false
    @State private var coffeeSelected: [String] = []
    @State private var drinkSelected: [String] = []
    @State private var dessertSelected: [String] = []
    @State private var isPresented: Bool = false
    
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = ChatGptViewModel.shared
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    @State var messages: [Message] = []
    @State var currentInput: String = ""
    @State var cancellables = Set<AnyCancellable>()
    
    let chatGptService = ChatGptService()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomHeader(action: {pathManager.path.removeLast()}, title: "메뉴 카피 생성")
            
            
            ScrollView {
                ContentArea {
                    VStack(alignment:.leading, spacing: 28) {
                        Text("선택한 키워드를 기반으로 카피가 생성됩니다. \n키워드를 선택하지 않을 시 랜덤으로 생성됩니다.")
                            .font(.body2Bold())
                            .foregroundStyle(Color.gray4)
                        VStack(alignment: .leading, spacing: 28) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("메뉴 이름 *")
                                    .foregroundStyle(Color.gray5)
                                    .font(.body1Bold())
                                
                                CustomTextfield(text: $menuName, placeHolder: "아메리카노")
                                    .onChange(of: menuName)  {
                                        _ in if menuName.count >= 1 {
                                            isActive = true
                                        } else {
                                            isActive = false
                                        }
                                    }
                            }
                            VStack(alignment: .leading, spacing: 12) {
                                Text("특징")
                                    .foregroundStyle(Color.gray5)
                                    .font(.body1Bold())
                                
                                VStack(alignment: .leading, spacing: 18) {
                                    DisclosureGroup("커피", isExpanded: $isCoffeeOpened) {
                                        Keywords(keyName: KeywordsModel().coffeeKeys, selectedIndices: self.$coffeeSelected)
                                    }
                                    .foregroundStyle(Color.gray5)
                                    .font(.body2Bold())
                                    
                                    
                                    Divider()
                                    
                                    
                                    DisclosureGroup("음료") {
                                        Keywords(keyName: KeywordsModel().drinkKeys, selectedIndices: self.$drinkSelected)
                                    }
                                    .foregroundStyle(Color.gray5)
                                    .font(.body2Bold())
                                    
                                    Divider()
                                    
                                    
                                    DisclosureGroup("디저트") {
                                        Keywords(keyName: KeywordsModel().dessertKeys, selectedIndices: self.$dessertSelected)
                                    }
                                    .foregroundStyle(Color.gray5)
                                    .font(.body2Bold())
                                    
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            Spacer()
            CTABtn(btnLabel: "카피 생성", isActive: self.$isActive, action: {
                if isActive == true {
                    if coinManager.coin < 5 {
                        coinManager.coinUse()
                        sendMessage(coffeeSelected: coffeeSelected, dessertSelected: dessertSelected, drinkSelected: drinkSelected, menuName: menuName)
                        pathManager.path.append(.CaptionResult)
                    }
                    else {
                        isPresented.toggle()
                    }
                }
            })
            .alert(isPresented: $isPresented, content: {
                return Alert(title: Text("크래딧을 모두 소모하였습니다. 재생성이 불가능 합니다."))
            })
            .onTapGesture {
                hideKeyboard()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//#Preview {
//    MenuView()
//}

