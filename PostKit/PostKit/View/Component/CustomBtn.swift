//
//  CustomBtn.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI

struct CustomBasicBtn: View {
    var btnDescription: String
    var action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            RoundedRectangle(cornerRadius: radius1)
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .overlay {
                    Text(btnDescription)
                        .foregroundStyle(Color.white)
                }
               
        })
    }
}

// TODO: 색상 에셋 추가되면 색 바꿔야 해요
struct CustomBtn: View {
    var btnDescription: String
    @State private var isActive: Bool = false
    var action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            RoundedRectangle(cornerRadius: radius1)
                .foregroundColor(isActive ? Color.primary : Color.gray)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .overlay {
                    Text(btnDescription)
                        .foregroundStyle(Color.white)
                }
            
        })
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
                    .foregroundColor(Color.gray)
                    .overlay {
                        Text(leftBtnDescription)
                            .foregroundStyle(Color.black)
                    }
            })
            
            Button(action: {
                rightAction()
            }, label: {
                RoundedRectangle(cornerRadius: radius1)
                    .foregroundStyle(Color.primary)
                    .overlay {
                        Text(rightBtnDescription)
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
