//
//  HashtagView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/28.
//

import SwiftUI

struct HashtagView: View {
    @EnvironmentObject var pathManager: PathManager
    @State private var locationText = ""
    @State private var emphasizeText = ""
    @State private var isActive: Bool = false
    @State private var locationTags: [String] = []
    @State private var emphasizeTags: [String] = []
    @State private var showingAlert = false
    
    @State private var isShowingDescription = false
    @State private var popupState: PopOverType = .region
    
    var body: some View {
        ZStack {
        //TODO: GeometryReader 활용 해상도 수정 필요
            VStack(alignment: .leading, spacing: 0) {
                CustomHeader(action: {pathManager.path.removeLast()}, title: "해시태그 생성")
                
                ScrollView {
                    ContentArea {
                        VStack(alignment: .leading, spacing: 28) {
                            Text("입력한 지역명을 기반으로 해시태그가 생성됩니다. \n강조 키워드 미입력 시 기본 키워드만의 조합으로 생성됩니다.")
                                .font(.body2Bold())
                                .foregroundColor(.gray4)
                            
                            VStack(alignment: .leading, spacing: 28) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("지역명 *")
                                            .font(.body1Bold())
                                            .foregroundColor(.gray5)
                                        Spacer()
                                        HashtagPopover(isShowingDescription: $isShowingDescription)
                                            .border(.red)
                                        
                                    }
                                    ZStack(alignment: .topLeading) {
                                        CustomTextfield(text: $locationText, placeHolder: "한남동", customTextfieldState: .reuse) {
                                            if !locationText.isEmpty && locationTags.count <= 4 {
                                                locationTags.append(locationText)
                                                checkTags()
                                            } else if locationTags.count > 4 {
                                                showingAlert = true
                                            }
                                        }
                                        .alert(isPresented: $showingAlert) {
                                            Alert(title: Text(""), message: Text("최대 5개까지만 입력할 수 있습니다."),
                                                  dismissButton: .default(Text("확인")))
                                        }
                                    }
                                    Text("최대 5개까지 작성가능합니다.")
                                        .font(.body2Regular())
                                        .foregroundColor(.gray3)
                                    
                                    WrappingHStack(alignment: .leading) {
                                        ForEach(locationTags, id: \.self) { tag in
                                            CustomHashtag(tagText: tag) {
                                                locationTags.removeAll(where: { $0 == tag })
                                                checkTags()
                                            }
                                        }
                                    }
                                }
                                
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("강조키워드")
                                        .font(.body1Bold())
                                        .foregroundColor(.gray5)
                                    ZStack(alignment: .topLeading) {
                                        CustomTextfield(text: $emphasizeText, placeHolder: "마카롱", customTextfieldState: .reuse) {
                                            if !emphasizeText.isEmpty && emphasizeTags.count <= 4 {
                                                emphasizeTags.append(emphasizeText)
                                            } else if emphasizeTags.count > 4 {
                                                showingAlert = true
                                            }
                                        }
                                        .alert(isPresented: $showingAlert) {
                                            Alert(title: Text(""), message: Text("최대 5개까지만 입력할 수 있습니다."),
                                                  dismissButton: .default(Text("확인")))
                                        }
                                    }
                                    Text("최대 5개까지 작성가능합니다.")
                                        .font(.body2Regular())
                                        .foregroundColor(.gray3)
                                    
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
                }
                Spacer()
                CTABtn(btnLabel: "해시태그 생성", isActive: self.$isActive, action: {})
                
                    .navigationBarBackButtonHidden()
            }
            
            popoverView(.region)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(Color.gray5.opacity(0.3))
            
        }
       
    }
    
    
    @ViewBuilder
    func popoverView(_ type: PopOverType) -> some View {
        VStack(spacing: 0) {
            TriangleView()
                .foregroundColor(.gray1)
                .frame(width: 18, height: 12)
            ZStack() {
                RoundedRectangle(cornerRadius: radius1)
                    .frame(width: 200, height: 167)
                    .foregroundColor(.gray1)
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    switch type {
                    case .region:
                        VStack {
                            ForEach(0..<type.description.count, id: \.self) { index in
                                if index % 2 == 1 {
                                    Text(type.description[index])
                                        .foregroundColor(.gray5)
                                        .font(.body2Bold())
                                }
                                else {
                                    Text(type.description[index])
                                        .foregroundColor(.gray4)
                                        .font(.body2Regular())
                                }
                            }
                        }
                    case .keyword:
                        EmptyView()
                    }
                }
                .frame(width: 166, height: 119)
                
            }
            .offset(type.offset)
            
        }
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
