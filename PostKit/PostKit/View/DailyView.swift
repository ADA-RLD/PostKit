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
    @State private var isContentsOpened = [false, false, false]
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
                        Keywords(keyName: KeywordsModel().weatherKeys , selectedIndices: self.$weatherSelected)
                    .frame(height: isContentsOpened[0] ? 180 : 80)
                    
                    if !isContentsOpened[0] {
                        Button(action: {
                            withAnimation(.spring()) {
                                isContentsOpened[0].toggle()
                            }
                        }, label: {
                            Text("더보기")
                        })
                    }
            
                
                Divider()
                    .padding(.bottom, 18)
                
                Text("커피 / 음료")
                    .foregroundStyle(Color.gray5)
                    .font(.body1Bold())
                    .padding(.bottom, 12)
                
                Keywords(keyName: KeywordsModel().dailyCoffeeKeys, selectedIndices: self.$dailyCoffeeSelected)
                        .frame(height: isContentsOpened[1] ? 180 : 80)
                    
                    if !isContentsOpened[1] {
                        Button(action: {
                            withAnimation(.spring()) {
                                isContentsOpened[1].toggle()
                            }
                        }, label: {
                            Text("더보기")
                        })
                    }
            
                
                    Divider()
                        .padding(.bottom, 18)
                Text("디저트")
                    .foregroundStyle(Color.gray5)
                    .font(.body1Bold())
                    .padding(.bottom, 12)
                
                Keywords(keyName: KeywordsModel().dailyDessertKeys, selectedIndices: self.$dailyDessertSelected)
                        .frame(height: isContentsOpened[2] ? 140 : 80)
                    
                    if !isContentsOpened[2] {
                        Button(action: {
                            withAnimation(.spring()) {
                                isContentsOpened[2].toggle()
                            }
                        }, label: {
                            Text("더보기")
                        })
                    }
            
                    
                    Divider()
                        .padding(.bottom, 18)
            }
        }
            CustomBtn(btnDescription: "카피생성", isActive: self.$isActive, action: {
                
                pathManager.path.append(.Result)
            })
            .padding(.bottom, 12)
            
            
        }
        .padding(.horizontal,paddingHorizontal)
    }
}

#Preview {
    DailyView()
}

