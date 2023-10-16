//
//  SettingStoreView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI

struct SettingStoreView: View {
    @EnvironmentObject var pathManager: PathManager
    @EnvironmentObject var appstorageManager: AppstorageManager
    var body: some View {
        VStack {
            CustomHeader(action: {pathManager.path.removeLast()}, title: "매장 정보")
            VStack(alignment: .leading, spacing: 0) {
                Text("이름")
                    .font(.body1Bold())
                    .foregroundStyle(Color.gray5)
                CustomTextfield(textLimit: 15, menuName: appstorageManager.$cafeName, placeHolder: appstorageManager.cafeName)
                    .padding(.top,12)
                Spacer()
                CustomBtn(btnDescription: "저장", isActive: .constant(true), action: {pathManager.path.removeLast()})
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal,paddingHorizontal)
        }
            
    }
}

