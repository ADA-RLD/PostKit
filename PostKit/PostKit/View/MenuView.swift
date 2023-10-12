//
//  MenuView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var pathManager: PathManager
    @State private var isActive: Bool = false
    @State var menuName = ""
    @State var isCoffeeOpened = false
    @State var isDrinkOpened = false
    @State var isDessertOpened = false
    @State var coffeeSelected: [String] = []
    @State var drinkSelected: [String] = []
    @State var dessertSelected: [String] = []
    
    var body: some View {
        
        VStack(alignment:.leading) {
            Text("선택한 키워드를 기반으로 카피가 생성됩니다. \n키워드를 선택하지 않을 시 랜덤으로 생성됩니다.")
                .font(.body2Bold())
                .foregroundStyle(Color.gray4)
                .padding(.bottom, 28)
            
            Text("메뉴 이름 *")
                .foregroundStyle(Color.gray5)
                .font(.body1Bold())
                .padding(.bottom, 12)
            CustomTextfield(menuName: self.$menuName, placeHolder: "아메리카노")
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
                DisclosureGroup("커피") {
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
            
            CustomBtn(btnDescription: "카피생성", isActive: self.$isActive, action:{
                if isActive == true {
                    pathManager.path.append(.Result)}
            }
                )
                .padding(.bottom, 12)
            
            
        }.padding(.horizontal,paddingHorizontal)
            .onTapGesture {
                hideKeyboard()
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
