//
//  CaptionResultChangeView.swift
//  PostKit
//
//  Created by 신서연 on 2023/11/02.
//

import SwiftUI

struct ResultUpdateModalView: View {
    enum ResultUpdateType {
        case captionResult
        case hashtagResult
    }
    
    @Binding var showModal: Bool
    @Binding var isChange: Bool
    @State var stringContent = ""
    var resultUpdateType: ResultUpdateType = .captionResult
    var completion: (_ caption: String) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showModal = false
                }, label: {
                    Text("취소")
                        .font(.body1Regular())
                        .foregroundColor(Color.blue)
                })
                
                Spacer()
                
                Text(resultUpdateType == .captionResult ? "글 수정" : "해시태그 수정")
                    .font(.body1Bold())
                
                Spacer()
                
                Button(action: {
                    completion(stringContent)
                    showModal = false
                }, label: {
                    Text("저장")
                        .font(.body1Regular())
                        .foregroundColor(Color.blue)
                })
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            
            ContentArea {
                VStack(alignment: .leading) {
                    ScrollView(showsIndicators: false){
                        TextField("기본 텍스트", text: $stringContent, axis: .vertical)
                            .font(.body1Bold())
                            .foregroundColor(Color.gray5)
                            .onChange(of: stringContent){ _ in
                                isChange = true
                            }
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 400)
                .background(Color.gray1)
                .cornerRadius(radius2)
                .overlay(
                    RoundedRectangle(cornerRadius: radius2)
                        .stroke(Color.gray3, lineWidth: 1)
                )
            }
            Spacer()
        }
    }
}
