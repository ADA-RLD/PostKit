//
//  SettingToneView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI

struct SettingToneView: View {
    @State private var tone = ""
    var tones: [String] = ["기본","친구같은","전문적인","친절한","재치있는","열정적인","감성적인","활발한","세련된","우왕","개쩐다"]
    var body: some View {
        toggleBtns
    }
}


extension SettingToneView {
    private var toggleBtns: some View {
        VStack(alignment:.leading) {
            Text("원하는 톤을 선택하세요")
            Text("선택한 톤을 바탕으로 카피가 생성됩니다.")
            SelectTone(tone: self.$tone)
        }
        .padding(.horizontal,paddingHorizontal)
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
