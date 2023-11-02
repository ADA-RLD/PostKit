//
//  SelectTone.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct SelectTone: View {
    @Binding var selectedTones: [String]
    var body: some View {
        toggleBtns
    }
}

//MARK: Extension: View
extension SelectTone {
    private var toggleBtns: some View {
        VStack(alignment:.leading, spacing: 12) {
            // 배열에 추가되면 자동으로 생성하게 해주는 기능을 만들었어요!
            ForEach(0..<tones.count / 2 + 1, id: \.self) { rowIndex in
                HStack(spacing: 12) {
                    ForEach(0..<2) { columIndex in
                        let item = rowIndex * 2 + columIndex
                        //마지막 행에 추가가 안된 데이터의 값을 나타날때 생기는 오류 방지
                        if item < tones.count {
                            Button {
                                addTone(tone: tones[item])
                            } label: {
                                RoundedRectangle(cornerRadius: radius2)
                                    .stroke(selectedTones.contains(tones[item]) ? Color.main: Color.gray1, lineWidth: 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: radius2)
                                            .fill(selectedTones.contains(tones[item]) ? Color.sub: Color.gray1)
                                        )
                                    .frame(width:UIScreen.main.bounds.width/2 - paddingHorizontal - 6,height: 60)
                                    .overlay(alignment: .leading) {
                                        Text(tones[item])
                                            .font(.body1Bold())
                                            .padding(.leading, 20)
                                            .foregroundStyle(selectedTones.contains(tones[item]) ? Color.main: Color.gray4)
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}


// MARK: Extension: Function
extension SelectTone {
    private func addTone(tone: String) {
        
        if !selectedTones.contains(tone) {
            
            if selectedTones.count >= 3 {
                selectedTones.removeFirst()
                selectedTones.append(tone)
            }
            
            else {
                selectedTones.append(tone)
            }
            
        }
        else {
            if let firstIndex = selectedTones.firstIndex(of: tone) {
                selectedTones.remove(at: firstIndex)
            }
        }
    }
}
