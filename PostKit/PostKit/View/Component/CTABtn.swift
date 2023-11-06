//
//  CustomBtn.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI

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

struct AlertCustomDoubleBtn: View {
    var topBtnLabel: String
    var bottomBtnLabel: String
    var topAction: () -> Void
    var bottomAction: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                topAction()
            }, label: {
                Text(topBtnLabel)
                    .body2Bold(textColor: Color.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    .background(.gray5)
                    .cornerRadius(radius1)
            })
            
            Button(action: {
                bottomAction()
            }, label: {
                Text(bottomBtnLabel)
                    .body2Bold(textColor: .gray5)
            })
        }
    }
}


#Preview {
    VStack{
        CustomDoubleBtn(leftBtnLabel: "d", rightBtnLabel: "d", leftAction: {print("hello")}, rightAction: {print("hello")})
        AlertCustomDoubleBtn(topBtnLabel: "취소", bottomBtnLabel: "계속 생성", topAction: {print("hello")}, bottomAction: {print("hello")})
    }
}
