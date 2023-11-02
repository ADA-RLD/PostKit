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
    @State private var weatherSelected: [String] = []
    @State private var dailyCoffeeSelected: [String] = []
    @State private var dailyDessertSelected: [String] = []
    @State private var isContentsOpened = [false, false, false]
    @State private var isPresented: Bool = false
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
            //TODO: 모듈화 필요 BottomView로 변경 예정
            CTABtn(btnLabel: "카피 생성", isActive: .constant(true), action: {
                if coinManager.coin > CoinManager.minimalCoin {
                    Task{
                        sendMessage(weatherSelected: weatherSelected, dailyCoffeeSelected: dailyCoffeeSelected, dailyDessertSelected: dailyDessertSelected)
                        pathManager.path.append(.CaptionResult)
                        coinManager.coinUse()
                        print(coinManager.coin)
                    }
                }
                else {
                    isPresented.toggle()
                }
            })
            .alert(isPresented: $isPresented, content: {
                return Alert(title: Text("크래딧을 모두 소모하였습니다. 재생성이 불가능합니다."))
            })
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
                KeywordAppend()
                
                SelectTextLength(selected: $textLength)
                
            }
        }
    }
    // TODO: 빼먹을꺼 빼먹고 지울 예정
    private var beforeView: some View {
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
        
        return CTABtn(btnLabel: "카피 생성", isActive: .constant(true), action: {
            if coinManager.coin > CoinManager.minimalCoin {
                Task{
                    sendMessage(weatherSelected: weatherSelected, dailyCoffeeSelected: dailyCoffeeSelected, dailyDessertSelected: dailyDessertSelected)
                    pathManager.path.append(.CaptionResult)
                    coinManager.coinUse()
                    print(coinManager.coin)
                }
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


// MARK: View의 펑션들을 관리 하는 extension입니다. 추후 MVVM으로 변경이 필요합니다.
extension DailyView {
    
}

//#Preview {
//    DailyView()
//}

