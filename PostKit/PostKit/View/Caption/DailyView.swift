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
    @State private var isSelected: [String] = []
    @State private var isModalPresented: Bool = false
    @State private var isAlertPresented: Bool = false
    // TODO: 글길이가 숫자로 들어오는데 나중에 숫자로 바꾸겠습니다.
    @State private var textLength: Int = 1
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = ChatGptViewModel.shared
    
    //CoreData Manager
    let storeDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    @State var messages: [Message] = []
    @State var currentInput: String = ""
    let chatGptService = ChatGptService()
    
    var body: some View {
        VStack(spacing: 0) {
            headerArea()
            
            contents()

            Spacer()
            
            bottomArea()
        }
        .sheet(isPresented: $isModalPresented) {
            KeywordModal(selectKeyWords: $isSelected, modalType: .daily, pickerList: ["날씨/계절","커피/음료","디저트"])
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: View의 모둘화를 한 extension 모음입니다.
extension DailyView {
    //MARK: Header
    private func headerArea() -> some View {
        CustomHeader(action: {pathManager.path.removeLast()}, title: "일상글")
    }
    //MARK: ContentsView
    private func contents() -> some View {
        ContentArea {
            VStack(alignment: .leading, spacing: 16) {
                KeywordAppend(isModalToggle: $isModalPresented, selectKeyWords: $isSelected)

                SelectTextLength(selected: $textLength)
                
            }
        }
    }
    
    private func bottomArea() -> some View {
        CTABtn(btnLabel: "카피 생성", isActive: .constant(true), action: {
            if coinManager.coin > CoinManager.minimalCoin {
                Task{
//                        sendMessage(weatherSelected: weatherSelected, dailyCoffeeSelected: dailyCoffeeSelected, dailyDessertSelected: dailyDessertSelected)
                    pathManager.path.append(.CaptionResult)
                    coinManager.coinUse()
                    print(coinManager.coin)
                }
            }
            else {
                isAlertPresented.toggle()
            }
        })
        .alert(isPresented: $isAlertPresented, content: {
            return Alert(title: Text("크래딧을 모두 소모하였습니다. 재생성이 불가능합니다."))
        })
    }

}

