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
    @State private var weatherSelected: [String] = []
    @State private var dailyCoffeeSelected: [String] = []
    @State private var dailyDessertSelected: [String] = []
    @State private var isContentsOpened = [false, false, false]
    @State private var isPresented: Bool = false
    
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = ChatGptViewModel.shared
    
    //CoreData Manager
    let storeDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    @State var messages: [Message] = []
    @State var currentInput: String = ""
    @State var cancellables = Set<AnyCancellable>()
    
    let chatGptService = ChatGptService()
    
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

//#Preview {
//    DailyView()
//}

