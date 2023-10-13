//
//  SettingToneView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//


import SwiftUI

struct SettingToneView: View {
    
    @EnvironmentObject var pathManager: PathManager
    @State private var tone = ""
    @State private var isActive: Bool = false // 변경사항 생길 시 true
    
    var tones: [String] = ["기본","친구같은","전문적인","친절한","재치있는","열정적인","감성적인","활발한","세련된","우왕","개쩐다"]
    
    var body: some View {
        VStack(alignment:.leading) {
            CustomHeader(action: {
                pathManager.path.removeLast()
            }, title: "말투")
            VStack {
                toggleBtns
                Spacer()
                CustomBtn(btnDescription: "저장", isActive: self.$isActive) {
                    // TODO: 변경 사항 저장
                }
            }
            .padding(.horizontal,paddingHorizontal)
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension SettingToneView {
    private var toggleBtns: some View {
        SelectTone(tone: self.$tone)
    }
}

private func toggleBtn(answer: String) -> some View {
    Button {
        
    } label: {
        RoundedRectangle(cornerRadius: 16)
            .overlay {
                Text(answer)
            }
    }
}
#Preview {
    SettingToneView()
}
