//
//  CustomBtn.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI

// TODO: 색상 에셋 추가되면 색 바꿔야 해요
struct CustomBtn: View {
    var btnDescription: String
    @Binding var isActive: Bool
    var action: () -> Void
    var body: some View {
        VStack {
            Button(action: {
                action()
            }, label: {
                RoundedRectangle(cornerRadius: radius1)
                    .foregroundColor(isActive ? Color.main : Color.gray3)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .overlay {
                        Text(btnDescription)
                            .font(.body1Bold())
                            .foregroundStyle(Color.white)
                    }
                
            })
        }
        .padding(.vertical,12)

    }
}

// TODO: 색상 애셋 추가되면 색 바꿔야 합니다.
struct CustomDoubleeBtn: View {
    var leftBtnDescription: String
    var rightBtnDescription: String
    var leftAction: () -> Void
    var rightAction: () -> Void
    var body: some View {
        HStack {
            Button(action: {
                leftAction()
            }, label: {
                RoundedRectangle(cornerRadius: radius1)
                    .foregroundColor(Color.gray2)
                    .overlay {
                        Text(leftBtnDescription)
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
                        Text(rightBtnDescription)
                            .font(.body1Bold())
                            .foregroundStyle(.white)
                    }
            })
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
    }
}

#Preview {
    CustomDoubleeBtn(leftBtnDescription: "d", rightBtnDescription: "d", leftAction: {print("hello")}, rightAction: {print("hello")})
}
