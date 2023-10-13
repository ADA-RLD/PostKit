//
//  MainView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI

struct MainView: View {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @EnvironmentObject var pathManager: PathManager
    var body: some View {
        NavigationStack(path: $pathManager.path) {
            
            VStack(alignment: .leading, spacing: 28){
                SettingBtn(action: {pathManager.path.append(.SettingHome)})

                VStack(alignment:.leading ,spacing: 28){
                    Text("어떤 카피를 생성할까요?")
                        .fullScreenCover(isPresented: $isFirstLaunching) {
                            OnboardingView( isFirstLaunching: $isFirstLaunching)
                        }
                        .font(.system(size: 24,weight: .bold))
                    
                    VStack(spacing: 12){
                        NavigationBtn(header: "일상",description: "가벼운 카페 일상 글을 써요", action: {pathManager.path.append(.Daily)})
                        NavigationBtn(header: "메뉴",description: "카페의 메뉴에 대한 글을 써요", action: {pathManager.path.append(.Menu)})
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, paddingHorizontal)
            .padding(.top, paddingTop)
            .padding(.bottom, paddingBottom)
            
            // TODO: 뷰 만들면 여기 스위치문에 넣어주세요
            .navigationDestination(for: StackViewType.self) { stackViewType in
                switch stackViewType {
                case .Menu:
                    MenuView()
                case .Daily:
                    SettingView()
                case .SettingHome:
                    SettingView()
                case .SettingStore:
                    SettingStoreView()
                case .SettingTone:
                    SettingToneView()
                case .Result:
                    ResultView()
                }
            }
        }
    }
}

// MARK: - 카테고리 버튼
private func NavigationBtn(header: String, description: String,action: @escaping () -> Void) -> some View {
    VStack {
        Button(action: {
            action()
        }) {
            RoundedRectangle(cornerRadius: radius2)
                .frame(maxWidth: .infinity)
                .frame(height: 106)
                .overlay(alignment: .leading) {
                    VStack(alignment: .leading,spacing: 8) {
                        Text(header)
                            .font(.title2())
                            .foregroundStyle(Color.gray6)
                        Text(description)
                            .font(.body2Bold())
                            .foregroundStyle(Color.gray4)
                    }
                    .padding(.horizontal,16)
                }
                .foregroundStyle(Color.sub)
        }
    }
}

// MARK: - 설정 버튼
private func SettingBtn(action: @escaping () -> Void) -> some View {
    HStack(alignment: .center) {
        Spacer()
        Button(action: {
            action()
        }, label: {
            Image(systemName: "gearshape")
                .resizable()
                .foregroundStyle(Color.gray5)
                .frame(width: 24,height: 24)
        })
    }
}

//#Preview {
//    MainView()
//}
