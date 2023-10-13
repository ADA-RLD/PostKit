//
//  SettingView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var pathManager: PathManager
    
    var name: String?
    var body: some View {
        VStack{
            CustomHeader(action: {
                pathManager.path.removeLast()
            }, title: "설정")
            VStack(spacing: 40.0) {
                SettingInfo(info: "매장정보", Answer: name, action: {pathManager.path.append(.SettingStore)})
                SettingInfo(info: "말투", Answer: name, action: {pathManager.path.append(.SettingTone)})
                Spacer()
            }
            .padding(.horizontal,paddingHorizontal)
            .padding(.top, paddingTop)
            .padding(.bottom, paddingBottom)
        }
        .navigationBarBackButtonHidden(true)
    }
}

private func SettingInfo(info: String, Answer: String?,action: @escaping () -> Void) -> some View {
    HStack {
        Text(info)
            .font(.body1Bold())
            .foregroundStyle(Color.gray5)
        Spacer()
        Button {
            action()
        } label: {
            HStack(spacing: 8.0) {
                Text(Answer ?? "미입력")
                Text(Image(systemName: "chevron.right"))
            }
            .font(.body1Bold())
            .foregroundStyle(Color.gray4)
        }
    }
}
#Preview {
    SettingView()
}
