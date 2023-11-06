//
//  SelectTone.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.


import SwiftUI

struct SelectTone: View {
    @Binding var selectedTones: [String]
    
    //TODO: 임시데이터라 데이터 변경이 필요합니다
    let tones: [Tone] = [
        Tone(tone: "1", toneExample: "우리 카페, 맛과 분위기에 걸맞는 퀄리티! ☕✨", isBest: false),
        Tone(tone: "2", toneExample: "우리 카페, 맛과 분위기에 걸맞는 퀄리티! ☕✨", isBest: false),
        Tone(tone: "3", toneExample: "우리 카페, 맛과 분위기에 걸맞는 퀄리티! ☕✨", isBest: false),
        Tone(tone: "4", toneExample: "우리 카페, 맛과 분위기에 걸맞는 퀄리티! ☕✨", isBest: false),
        Tone(tone: "5", toneExample: "우리 카페, 맛과 분위기에 걸맞는 퀄리티! ☕✨", isBest: true),
        Tone(tone: "6", toneExample: "우리 카페, 맛과 분위기에 걸맞는 퀄리티! ☕✨", isBest: false),
        Tone(tone: "7", toneExample: "우리 카페, 맛과 분위기에 걸맞는 퀄리티! ☕✨", isBest: false),
        Tone(tone: "8", toneExample: "우리 카페, 맛과 분위기에 걸맞는 퀄리티! ☕✨", isBest: false),
        Tone(tone: "9", toneExample: "우리 카페, 맛과 분위기에 걸맞는 퀄리티! ☕✨", isBest: false),
        Tone(tone: "10", toneExample: "우리 카페, 맛과 분위기에 걸맞는 퀄리티! ☕✨", isBest: false)
    ]
    
    var body: some View {
        toggleBtns
    }
}

//MARK: Extension: View
extension SelectTone {
    private var toggleBtns: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 배열에 추가되면 자동으로 생성하게 해주는 기능을 만들었어요!
            ForEach(tones, id: \.self) { rowIndex in
                toggleBtn(concept: rowIndex.tone, conceptExample: rowIndex.toneExample, isBest: rowIndex.isBest) {
                    addTone(tone: rowIndex.tone)
                    print(selectedTones)
                }
            }
        }
    }
    
    // TODO: isbest가 true일때 색변경이 안되는 오류 수정해야합니다.
    private func toggleBtn(concept: String, conceptExample: String, isBest: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: radius1)
                .stroke(selectedTones.contains(concept) ? Color.main: Color.gray1, lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: radius2)
                        .fill(selectedTones.contains(concept) ? Color.sub : Color.gray1)
                )
                // TODO: padding이 개념인 듯..?
                .frame(height: 84)
                .foregroundColor(Color.gray1)
                .overlay(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Text(concept)
                                .font(.body1Bold())
                                .foregroundColor(selectedTones.contains(concept) ? Color.gray5 : Color.gray4)
                            
                            if isBest {
                                Text("BEST")
                                    .font(.body2Bold())
                                    .foregroundColor(Color.main)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .background(Color.main.opacity(0.5))
                            }
                        }
                        Text(conceptExample)
                            .body2Regular(textColor: .gray4)
                    }
                    .padding(.all, 20)
                }
        }
    }
}

// MARK: Extension: Function => view model로 빼주세요...
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
