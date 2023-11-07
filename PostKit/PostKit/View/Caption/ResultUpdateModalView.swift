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
    @Binding var stringContent: String
    @FocusState private var isTextFieldFocused: Bool
    var resultUpdateType: ResultUpdateType = .captionResult
    var completion: (_ caption: String) -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack {
                    Button(action: {
                        showModal = false
                    }, label: {
                        Text("취소")
                            .body1Bold(textColor: .main)
                    })
                    
                    Spacer()
                    
                    Text(resultUpdateType == .captionResult ? "글 수정" : "해시태그 수정")
                        .body1Bold(textColor: .gray6)
                    
                    Spacer()
                    
                    Button(action: {
                        completion(stringContent)
                        showModal = false
                    }, label: {
                        Text("저장")
                            .body1Bold(textColor: .main)
                    })
                }
                .padding(.horizontal, 16)
                .frame(height: 60)
                
                ContentArea {
                    VStack(alignment: .leading) {
                        TextField("기본 텍스트", text: $stringContent, axis: .vertical)
                            .font(.body1Bold())
                            .foregroundColor(Color.gray5)
                            .onChange(of: stringContent) { _ in
                                isChange = true
                            }
                            .focused($isTextFieldFocused)
                            .onAppear {
                                isTextFieldFocused = true
                            }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 400)
                    .background(Color.gray1)
                    .cornerRadius(radius1)
                    .overlay(
                        RoundedRectangle(cornerRadius: radius1)
                            .stroke(Color.gray3, lineWidth: 1)
                    )
                }
                Spacer()
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

