//
//  SettingView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI

struct SettingView: View {
    var name: String?
    var body: some View {
        VStack {
            SettingInfo(info: "매장정보", Answer: name, action: {print("hello")})
            SettingInfo(info: "말투", Answer: name, action: {print("hello")})
                .padding(.top,40)
        }
        .padding(.horizontal,20)
    }
}


private func SettingInfo(info: String, Answer: String?,action: @escaping () -> Void) -> some View {
    HStack {
        Text(info)
            .font(.system(size: 16))
        Spacer()
        Button {
            action()
        } label: {
            Text(Answer ?? "미입력").font(.system(size: 16)) + Text(Image(systemName: "chevron.right")).font(.system(size: 16))
                
        }

    }
}
#Preview {
    SettingView()
}
