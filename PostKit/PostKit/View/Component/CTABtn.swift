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
                RoundedRectangle(cornerRadius: radius1)
                    .foregroundColor(isActive ? Color.main : Color.gray3)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .overlay {
                        Text(btnLabel)
                            .font(.body1Bold())
                            .foregroundStyle(Color.white)
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
                RoundedRectangle(cornerRadius: radius1)
                    .foregroundColor(Color.gray2)
                    .overlay {
                        Text(leftBtnLabel)
                            .font(.body1Bold())
                            .foregroundStyle(Color.gray5)
                    }
            })
            
            Button(action: {
                rightAction()
            }, label: {
                RoundedRectangle(cornerRadius: radius1)
                    .foregroundStyle(Color.main)
                    .overlay {
                        Text(rightBtnLabel)
                            .font(.body1Bold())
                            .foregroundStyle(.white)
                    }
            })
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .padding(.horizontal,paddingHorizontal)
        .padding(.vertical,12)
      
    }
}

#Preview {
    CustomDoubleBtn(leftBtnLabel: "d", rightBtnLabel: "d", leftAction: {print("hello")}, rightAction: {print("hello")})
}
