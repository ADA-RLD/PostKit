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
        ZStack (alignment: .leading) {
            VStack {
                Text(resultText)
                    .font(.body1Bold())
                    .foregroundColor(Color.gray5)
//                                .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
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
                            .font(.body2Bold())
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 6, leading: radius1, bottom: 6, trailing: radius1))
                    }).background(RoundedRectangle(cornerRadius: radius1).fill(Color.main))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 400)
            .background(Color.gray1)
            .cornerRadius(radius2)
        }
    }
}

