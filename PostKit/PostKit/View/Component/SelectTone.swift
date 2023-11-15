//
//  SelectTone.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.

import SwiftUI

struct SelectTone: View {
    @Binding var selectedTones: [String]
    @Binding var isShowToast: Bool
    
    //TODO: 임시데이터라 데이터 변경이 필요합니다
    let tones: [Tone] = [
        Tone(tone: "친절한", toneExample: "에스프레소와 부드러운 우유가 조화롭게 어우러져요.", isBest: true),
        Tone(tone: "감성적인", toneExample: "바쁜 일상 속 작은 여유를 선사하는 부드러운 맛이에요.", isBest: true),
        Tone(tone: "논리적인", toneExample: "깊고 진한 에스프레소와 부드러운 우유의 조화를 경험하세요.", isBest: false),
        Tone(tone: "간단한", toneExample: "부드러운 풍미의 카페라떼에요.", isBest: false),
        Tone(tone: "애교있는", toneExample: "부드러운 풍미의 카페라떼가 여러분을 기다리고 있어요.", isBest: false),
        Tone(tone: "재치있는", toneExample: "입 안 가득 부드러운 풍미에 눈이 번쩍 떠질지도 몰라요!", isBest: false)
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
    
    private func toggleBtn(concept: String, conceptExample: String, isBest: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack{
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(concept)
                            .body1Bold(textColor: selectedTones.contains(concept) ? Color.gray5 : Color.gray4)
                        
                        if isBest {
                            Text("BEST")
                                .body2Bold(textColor: .main)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 6)
                                .background(Color.tertiary)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    }
                    Text(conceptExample)
                        .body2Bold(textColor: .gray4)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.all, 20)
            .background(selectedTones.contains(concept) ? Color.sub : Color.gray1)
            .cornerRadius(radius1)
            .overlay(
                RoundedRectangle(cornerRadius: radius1)
                    .stroke(selectedTones.contains(concept) ? Color.main : Color.gray1, lineWidth: 2)
            )
        }
    }
}

extension SelectTone {
    private func addTone(tone: String) {
        if !selectedTones.contains(tone) && selectedTones.count < 3 {
            selectedTones.append(tone)
        }
        else if selectedTones.contains(tone) {
            selectedTones.removeAll(where: {$0 == tone})
        }
        else {
           isShowToast = true
        }
    }
}
