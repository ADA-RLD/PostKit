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
    @EnvironmentObject var pathManager: PathManager
    @State private var isActive: Bool = false
    @State private var menuName = ""
    @State private var isCoffeeOpened = true
    @State private var isDrinkOpened = false
    @State private var isDessertOpened = false
    @State private var coffeeSelected: [String] = []
    @State private var drinkSelected: [String] = []
    @State private var dessertSelected: [String] = []
    @State private var isAlertPresented: Bool = false
    @State private var isModalPresented: Bool = false
    @State private var isSelected: [String] = []
    @State private var textLength: Int = 1
    
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var loadingModel = LoadingViewModel.shared
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    @State var messages: [Message] = []
    @State var cancellables = Set<AnyCancellable>()
    
    let textLengthArr: [Int] = [100, 200, 300]
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            headerArea()
            contents()
            Spacer()
            bottomArea()
        }
        .sheet(isPresented: $isModalPresented, content: {
            KeywordModal(selectKeyWords: $isSelected, firstSegementSelected: $coffeeSelected, secondSegementSelected: $drinkSelected, thirdSegementSelected: $dessertSelected, modalType: .menu ,pickerList: ["커피","음료","디저트"])
        })
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarBackButtonHidden()
    }
}

extension MenuView {
    private func headerArea() -> some View {
        CustomHeader(action: {pathManager.path.removeLast()}, title: "메뉴 글")
    }
    
    private func contents() -> some View {
        ContentArea {
            VStack(alignment: .leading, spacing: 16) {
                menuInput()
                
                KeywordAppend(isModalToggle: $isModalPresented, selectKeyWords: $isSelected)
                
                SelectTextLength(selected: $textLength)
            }
        }
    }
    
    private func menuInput() -> some View {
        RoundedRectangle(cornerRadius: radius1)
            .stroke(Color.gray2)
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 123)
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("메뉴 이름*")
                        .body1Bold(textColor: .gray5)
                    CustomTextfield(text: $menuName, placeHolder: "아이스 아메리카노")
                        .onChange(of: menuName)  { _ in if menuName.count >= 1 {
                                isActive = true
                            } else {
                                isActive = false
                            }
                        }
                }
                .padding(.all,20)
            }
    }
    
    private func bottomArea() -> some View {
        CTABtn(btnLabel: "글 생성", isActive: self.$isActive, action: {
            if isActive == true {
                if coinManager.coin > CoinManager.minimalCoin {
                    pathManager.path.append(.Loading)
                    
                    Task{
                        loadingModel.isCaptionGenerate = false
                        //선택된 옵션들을 가져갑니다.
                        loadingModel.inputArray += coffeeSelected + dessertSelected + drinkSelected
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                            sendMessage(coffeeSelected: coffeeSelected, dessertSelected: dessertSelected, drinkSelected: drinkSelected, menuName: menuName, textLenth: textLengthArr[textLength])
                        }
                    }
                }
                else {
                    isAlertPresented.toggle()
                }
            }
        })
        .alert(isPresented: $isAlertPresented, content: {
            return Alert(title: Text("크래딧을 모두 소모하였습니다. 재생성이 불가능합니다."))
        })
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

