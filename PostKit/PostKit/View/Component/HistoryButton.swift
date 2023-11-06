//
//  HistoryButton.swift
//  PostKit
//
//  Created by 신서연 on 2023/11/02.
//

import SwiftUI

struct HistoryButton: View {
    
    @Binding var resultText: String
    var buttonText: String
    var historyRightAction: () -> Void
    var historyLeftAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(resultText)
                    .body1Bold(textColor: .gray5)

                Spacer()
                HStack(alignment: .bottom) {
                    Button(action: {
                        // TODO: 좋아요 button action 추가
                        historyLeftAction()
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
                        historyRightAction()
                    }, label: {
                        Text(buttonText)
                            .body2Bold(textColor: .white)
                            .padding(EdgeInsets(top: 6, leading: 18, bottom: 6, trailing: 18))
                    }).background(RoundedRectangle(cornerRadius: 20).fill(Color.main))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 400)
            .background(Color.gray1)
            .cornerRadius(20)
        }
    }
}

