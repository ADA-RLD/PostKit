//
//  DailyView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/13.
//

import SwiftUI
import CoreData
import Combine

struct DailyView: View {
    @EnvironmentObject var pathManager: PathManager
    @State private var isActive: Bool = false
    @State private var isSelected: [String] = []
    @State private var isModalPresented: Bool = false
    // TODO: 글길이가 숫자로 들어오는데 나중에 숫자로 바꾸겠습니다.
    @State private var textLength: Int = 1
    @State private var showAlert: Bool = false
    @State private var weatherSelected: [String] = []
    @State private var dailyCoffeeSelected: [String] = []
    @State private var dailyDessertSelected: [String] = []
    @State private var customKeyword: [String] = []
    @State var messages: [Message] = []
    @State var cancellables = Set<AnyCancellable>()
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var loadingModel = LoadingViewModel.shared
    
    //CoreData Manager
    let storeDataManager = CoreDataManager.instance
    let textLengthArr: [Int] = [100, 200, 300]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerArea()
                contents()
                Spacer()
                bottomArea()
            }
            .sheet(isPresented: $isModalPresented) {
                KeywordModal(selectKeyWords: $isSelected, firstSegementSelected: $weatherSelected, secondSegementSelected: $dailyCoffeeSelected, thirdSegementSelected: $dailyDessertSelected, customKeywords: $customKeyword, modalType: .daily, pickerList: ["날씨 ・ 계절","커피 ・ 음료","디저트"])
                    .presentationDragIndicator(.visible)
            }
            if showAlert {
                CustomAlertMessage(alertTopTitle: "크레딧을 모두 사용했어요", alertContent: "크레딧이 있어야 생성할 수 있어요\n크레딧은 자정에 충전돼요", topBtnLabel: "확인") {pathManager.path.removeAll()}
                }
            }
        .navigationBarBackButtonHidden()
        }
    }

// MARK: View의 모둘화를 한 extension 모음입니다.
extension DailyView {
    //MARK: Header
    private func headerArea() -> some View {
        CustomHeader(action: {pathManager.path.removeLast()}, title: "일상 글")
    }
    
    //MARK: ContentsView
    private func contents() -> some View {
        ContentArea {
            VStack(alignment: .leading, spacing: 40) {
                KeywordAppend(isModalToggle: $isModalPresented, selectKeyWords: $isSelected)
                    .onChange(of: isSelected) { _ in
                        isActive = true
                    }
                SelectTextLength(selected: $textLength)
            }
        }
    }
    
    private func bottomArea() -> some View {
        CTABtn(btnLabel: "글 생성", isActive: $isActive, action: {
            if coinManager.coin >= CoinManager.captionCost {
                pathManager.path.append(.Loading)
              
                Task{
                    loadingModel.isCaptionGenerate = false
                    //배열에 추가해서 가져갑니다.
                    loadingModel.inputArray = [isSelected, weatherSelected, dailyCoffeeSelected, dailyDessertSelected].flatMap { $0 }
                    loadingModel.inputArray = removeDuplicates(from: loadingModel.inputArray)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                        sendMessage(weatherSelected: weatherSelected, dailyCoffeeSelected: dailyCoffeeSelected, dailyDessertSelected: dailyDessertSelected, customKeywords: customKeyword, textLength: textLengthArr[textLength])
                        print(coinManager.coin)
                    }
                }
            } else {
                showAlert = true
            }
        })
    }
    
    private func removeDuplicates(from array: [String]) -> [String] {
        var uniqueArray: [String] = []
        
        for element in array {
            if !uniqueArray.contains(element) {
                uniqueArray.append(element)
            }
        }
        
        return uniqueArray
    }
}
