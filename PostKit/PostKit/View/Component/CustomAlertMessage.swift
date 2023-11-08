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
}

struct CustomAlertMessageDouble: View {
    var alertTopTitle: String
    var alertContent: String
    var topBtnLabel: String
    var bottomBtnLabel: String
    var topAction: () -> Void
    var bottomAction: () -> Void
    @Binding var showAlert: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            VStack(spacing: 36) {
                VStack(spacing: 8) {
                    Text(alertTopTitle)
                        .body1Bold(textColor: .gray6)
                    Text(alertContent)
                        .body2Bold(textColor: .gray4)
                        .multilineTextAlignment(.center)
                }
                AlertCustomDoubleBtn(topBtnLabel: topBtnLabel, bottomBtnLabel: bottomBtnLabel, topAction: topAction, bottomAction: bottomAction)
            }
            .padding(.vertical, 48)
            .background(
                RoundedRectangle(cornerRadius: radius2)
                    .frame(width: 280)
                    .foregroundColor(.gray1)
            )
        }.edgesIgnoringSafeArea(.all)
    }
}

struct CustomAlertMessage: View {
    var alertTopTitle: String
    var alertContent: String
    var topBtnLabel: String
    var topAction: () -> Void
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
                AlertCustomBtn(topBtnLabel: topBtnLabel, topAction: topAction)
            }
            .padding(.vertical, 48)
            .background(
                RoundedRectangle(cornerRadius: radius2)
                    .frame(width: 280)
                    .foregroundColor(.gray1)
            )
        }.edgesIgnoringSafeArea(.all)
    }
}
