//
//  CustomAlertMessage.swift
//  PostKit
//
//  Created by 신서연 on 2023/11/07.
//

import SwiftUI

struct CustomAlertMessage: View {
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("히스토리가 삭제됩니다.")
                    .body1Bold(textColor: .gray6)
                Text("영원히...")
                    .body2Bold(textColor: .gray4)
            }
            AlertCustomDoubleBtn(topBtnLabel: "삭제", bottomBtnLabel: "취소", topAction: {}, bottomAction: {})
        }
        .padding(.vertical, 48)
        .background(
        RoundedRectangle(cornerRadius: radius1)
            .foregroundColor(.white)
        )
    }
}
//48, 88.5
#Preview {
    CustomAlertMessage()
}
