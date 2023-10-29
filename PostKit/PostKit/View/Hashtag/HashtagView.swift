//
//  HashtagView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/28.
//

import SwiftUI

struct HashtagView: View {
    @State private var locationText = ""
    @State private var emphasizeText = ""
    @State private var isActive: Bool = false
    @State private var locationTags: [String] = []
    @State private var emphasizeTags: [String] = []
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomHeader(action: {}, title: "해시태그 생성")
            
            ScrollView {
                ContentArea {
                    VStack(alignment: .leading, spacing: 28) {
                        Text("입력한 지역명을 기반으로 해시태그가 생성됩니다. \n강조 키워드 미입력 시 기본 키워드만의 조합으로 생성됩니다.")
                            .font(.body2Bold())
                            .foregroundStyle(.gray4)
                        
                        VStack(alignment: .leading, spacing: 28) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("지역명 *")
                                    .font(.body1Bold())
                                    .foregroundStyle(.gray5)
                                CustomTextfield(text: $locationText, placeHolder: "한남동", customTextfieldState: .reuse) {
                                    if !locationText.isEmpty {
                                        locationTags.append(locationText)
                                        checkTags()
                                    }
                                }
                            }
                            WrappingHStack(alignment: .leading) {
                                ForEach(locationTags, id: \.self) { tag in
                                    CustomHashtag(tagText: tag) {
                                        locationTags.removeAll(where: { $0 == tag })
                                        checkTags()
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("강조키워드")
                                    .font(.body1Bold())
                                    .foregroundStyle(.gray5)
                                CustomTextfield(text: $emphasizeText, placeHolder: "마카롱", customTextfieldState: .reuse) {
                                    if !emphasizeText.isEmpty {
                                        emphasizeTags.append(emphasizeText)
                                        
                                    }
                                }
                            }
                            WrappingHStack(alignment: .leading) {
                                ForEach(emphasizeTags, id: \.self) { tag in
                                    CustomHashtag(tagText: tag) {
                                        emphasizeTags.removeAll(where: { $0 == tag })
                                    }
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            Spacer()
            CTABtn(btnLabel: "해시태그 생성", isActive: self.$isActive, action: {})
        }
        .navigationBarBackButtonHidden()
    }
    
    private func checkTags() {
        if !locationTags.isEmpty {
            isActive = true
        } else {
            isActive = false
        }
    }
}

#Preview {
    HashtagView()
}
