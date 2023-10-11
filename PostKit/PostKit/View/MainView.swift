//
//  MainView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI



struct MainView: View {
    @EnvironmentObject var pathManager: PathManager
    var body: some View {
        NavigationStack(path: $pathManager.path) {
            
            VStack(alignment: .leading){
                SettingBtn(action: {pathManager.path.append(.SettingHome)})
                Text("어떤 카피를 생성할까요?")
                    .font(.system(size: 24,weight: .bold))
                NavigationBtn(header: "일상",description: "가벼운 카페 일상 글을 써요", action: {pathManager.path.append(.Daily)})
                NavigationBtn(header: "메뉴",description: "카페의 메뉴에 대한 글을 써요", action: {pathManager.path.append(.Menu)})
            }
            .padding(.horizontal,20)
            
            // TODO: 뷰 만들면 여기 스위치문에 넣어주세요
            .navigationDestination(for: StackViewType.self) { stackViewType in
                switch stackViewType {
                case .Menu:
                    SettingView()
                case .Daily:
                    SettingView()
                case .SettingHome:
                    SettingView()
                case .SettingStore:
                    SettingStoreView()
                case .SettingTone:
                    SettingToneView()
                }
                
            }
        }
    }
}

private func NavigationBtn(header: String, description: String,action: @escaping () -> Void) -> some View {
    VStack {
        Button(action: {
            action()
        }) {
            RoundedRectangle(cornerRadius: 18)
                .frame(maxWidth: .infinity)
                .frame(height: 106)
                .overlay(alignment: .leading) {
                    VStack(alignment: .leading,spacing: 0) {
                        Text(header)
                            .font(.system(size: 20,weight: .bold))
                            .foregroundStyle(Color.black)
                        Text(description)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.gray.opacity(0.8))
                            .padding(.top,12)
                    }
                    .padding(.horizontal,16)
                }
            
                .foregroundStyle(Color.pink.opacity(0.2))
        }
        
    }
    
}

private func SettingBtn(action: @escaping () -> Void) -> some View {
    HStack(alignment: .center) {
        Spacer()
        Button(action: {
            action()
        }, label: {
            Image(systemName: "gearshape")
                .resizable()
                .foregroundStyle(Color.black)
                .frame(width: 24,height: 24)
        })
    }
}

#Preview {
    MainView()
}
