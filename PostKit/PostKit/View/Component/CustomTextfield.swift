//
//  CustomTextfield.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI

struct CustomTextfield: View {
    @ObservedObject var keyboard: KeyboardObserver = KeyboardObserver()
    @Binding var menuname : String
    var placeHolder: String = ""
    var body: some View {
        TextField(placeHolder, text: $menuname, prompt: Text(placeHolder).foregroundStyle(Color.gray4))
            .font(.system(size: 16))
            .fontWeight(.bold)
            .tint(Color.black)
            .padding()
            .background(Color.gray1)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(keyboard.isShowing ? Color.gray3 : Color.gray2)
            }
            .onChange(of: menuname) {
                _ in if menuname.count > 15 {
                    menuname = String(menuname.prefix(15))
                }
            }
            .onAppear {
                self.keyboard.addObserver()
            }
            .onDisappear {
                self.keyboard.removeObserver()
            }
            .overlay(alignment: .trailing) {
                Text("\(self.menuname.count.description) /15")
                    .foregroundStyle(keyboard.isShowing ? Color.black : Color.gray4)
                    .padding(.trailing,20)
            }
    }
}



