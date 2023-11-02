//
//  HistoryButton.swift
//  PostKit
//
//  Created by 신서연 on 2023/11/02.
//

import SwiftUI

struct HistoryButton: View {
    var buttonText: String  
    var historyRightAction: () -> Void
    
    var body: some View {
            HStack(alignment: .bottom) {
                Button(action: {
                    
                }, label: {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("좋아요")
                    }
                    .font(.body2Bold())
                    .foregroundColor(.main)
                    .padding(EdgeInsets(top: 6, leading: radius2, bottom: 6, trailing: radius2))
                })
                .overlay {
                    RoundedRectangle(cornerRadius: radius1)
                        .stroke(Color.main,lineWidth: 2)
                }
                Spacer()
                Button(action: {
                    //수정하기 & 복사하기
                    historyRightAction()
                }, label: {
                    Text(buttonText)
                        .font(.body2Bold())
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 6, leading: radius1, bottom: 6, trailing: radius1))
                }).background(RoundedRectangle(cornerRadius: radius1).fill(Color.main))
            }
        }
    }

#Preview {
    HistoryButton(buttonText: "저장하기", historyRightAction: {})
}
