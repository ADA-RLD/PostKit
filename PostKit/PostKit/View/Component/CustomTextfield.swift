//
//  CustomTextfield.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI

struct CustomTextfield: View {
    @StateObject var keyboard: KeyboardObserver = KeyboardObserver()
    @Binding var menuName : String
    var placeHolder: String
    var body: some View {
        TextField(placeHolder, text: $menuName, prompt: Text(placeHolder).foregroundStyle(Color.gray4))
            .font(.body1Bold())
            .tint(Color.black)
            .padding()
            .background(Color.gray1)
            .clipShape(RoundedRectangle(cornerRadius: radius1))
            .overlay {
                RoundedRectangle(cornerRadius: radius1)
                    .stroke(keyboard.isShowing ? Color.gray3 : Color.gray2)
            }
            .onChange(of: menuName) {
                _ in if menuName.count > 15 {
                    menuName = String(menuName.prefix(15))
                }
            }
            .onAppear {
                self.keyboard.addObserver()
            }
            .onDisappear {
                self.keyboard.removeObserver()
            }
            .overlay(alignment: .trailing) {
                Text("\(self.menuName.count.description) /15")
                    .font(.body2Regular())
                    .foregroundStyle(keyboard.isShowing ? Color.black : Color.gray4)
                    .padding(.trailing, paddingHorizontal)
            }
    }
}



