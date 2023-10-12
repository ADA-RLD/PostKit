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
            // 배열에 추가되면 자동으로 생성하게 해주는 기능을 만들었어요!
            ForEach(0..<tones.count / 2 + 1, id: \.self) { rowIndex in
                HStack {
                    ForEach(0..<2) { columIndex in
                        let item = rowIndex * 2 + columIndex
                        //마지막 행에 추가가 안된 데이터의 값을 나타날때 생기는 오류 방지
                        if item < tones.count {
                            Button {
                                tone = tones[item]
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .overlay(alignment: .leading) {
                                        Text(tones[item])
                                            .padding(.leading,paddingHorizontal)
                                    }
                                    .foregroundStyle(tones[item] == tone ? Color.pink.opacity(0.7): Color.gray.opacity(0.4))
                                    .frame(width:UIScreen.main.bounds.width/2 - paddingHorizontal,height: 60)
                            }
                        }
                    }
                }
            }
            CustomDoubleeBtn(leftBtnDescription: "샘플", rightBtnDescription: "샘플2", leftAction: {print("hello")}, rightAction: {print("hello")})
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
