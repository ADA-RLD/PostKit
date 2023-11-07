//
//  CustomAlertMessage.swift
//  PostKit
//
//  Created by 신서연 on 2023/11/07.
//

import SwiftUI

enum AlertType {
    case historyCaption
    case historyHashtag
    case loading
    case regenerate
    case credit
}

struct CustomAlertMessage: View {
    var alertTopTitle: String
    var alertContent: String
    var topBtnLabel: String
    var bottomBtnLabel: String
    var topAction: () -> Void
    var bottomAction: () -> Void
    @Binding var showAlert: Bool
    @Binding var isDeleted: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            VStack(spacing: 36) {
                VStack(spacing: 8) {
                    Text(alertTopTitle)
                        .body1Bold(textColor: .gray6)
                    Text(alertContent)
                        .body2Bold(textColor: .gray4)
                }
                AlertCustomDoubleBtn(topBtnLabel: topBtnLabel, bottomBtnLabel: bottomBtnLabel, topAction: {
                    topAction()
                }, bottomAction: {
                    bottomAction()
                })
            }
            .padding(.vertical, 48)
            .background(
                RoundedRectangle(cornerRadius: radius1)
                    .frame(width: 280)
                    .foregroundColor(.gray1)
            )
        }.edgesIgnoringSafeArea(.all)
    }
}

//#Preview {
//    CustomAlertMessage(alertTopTitle: "히스토리가 삭제됩니다.", alertContent: "영원히...", topBtnLabel: "삭제", bottomBtnLabel: "취소", topAction: {}, bottomAction: {}, showAlert: .constant(false))
//}
