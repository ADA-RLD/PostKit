//
//  CustomBtn.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI

// TODO: 색상 에셋 추가되면 색 바꿔야 해요
struct CTABtn: View {
    var btnLabel: String
    @Binding var isActive: Bool
    var action: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                action()
            }, label: {
                VStack(alignment: .center) {
                    Text(btnLabel)
                        .body1Bold(textColor: .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18.5)
                        .background(isActive ? Color.main : Color.gray3)
                        .background(in: RoundedRectangle(cornerRadius: radius1))
                }
            })
            .disabled(!isActive)
        }
        .padding(.horizontal,paddingHorizontal)
        .padding(.vertical,12)
    }
}

// TODO: 색상 애셋 추가되면 색 바꿔야 합니다.
struct CustomDoubleBtn: View {
    var leftBtnLabel: String
    var rightBtnLabel: String
    var leftAction: () -> Void
    var rightAction: () -> Void
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                leftAction()
            }, label: {
                Text(leftBtnLabel)
                    .body1Bold(textColor: .gray5)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,18.5)
                    .background(Color.gray2)
                    .background(in: RoundedRectangle(cornerRadius: radius1))
 
            })
            
            Button(action: {
                rightAction()
            }, label: {
                Text(leftBtnLabel)
                    .body1Bold(textColor: .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,18.5)
                    .background(Color.main)
                    .background(in: RoundedRectangle(cornerRadius: radius1))

            })
        }
        .padding(.horizontal,paddingHorizontal)
        .padding(.vertical,12)
    }
}

#Preview {
    CustomDoubleBtn(leftBtnLabel: "d", rightBtnLabel: "d", leftAction: {print("hello")}, rightAction: {print("hello")})
}
