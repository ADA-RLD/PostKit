//
//  CustomTextfield.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI

struct CustomTextfield: View {
    enum CustomTextfieldState {
        case one
        case reuse
    }
    
    @StateObject var keyboard: KeyboardObserver = KeyboardObserver()
    @Binding var text : String
    @FocusState private var isFocused: Bool
    
    var placeHolder: String
    var customTextfieldState: CustomTextfieldState = .one
    var completion: () -> Void = {}
    var textLimit = 15
    
    var body: some View {
        TextField(placeHolder, text: $text, prompt: Text(placeHolder).foregroundColor(Color.gray3))
            .focused($isFocused)
            .font(.body1Bold())
            .tint(Color.gray6)
            .padding()
            .background(Color.gray1)
            .clipShape(RoundedRectangle(cornerRadius: radius1))
            .overlay {
                RoundedRectangle(cornerRadius: radius1)
                    .stroke(isFocused ? Color.gray3 : Color.gray2)
            }
            .onChange(of: text) {
                _ in if text.count > textLimit {
                    text = String(text.prefix(textLimit))
                }
            }
            .onAppear {
                self.keyboard.addObserver()
            }
            .onDisappear {
                self.keyboard.removeObserver()
            }
            .overlay(alignment: .trailing) {
                Text("\(self.text.count.description)/\(textLimit)")
                    .font(.body2Regular())
                    .foregroundStyle(isFocused ? Color.gray6 : Color.gray4)
                    .padding(.trailing, paddingHorizontal)
            }
            .submitLabel(.done)
            .onSubmit {
                if customTextfieldState == .reuse {
                    completion()
                    text = ""
                }
            }
    }
}



