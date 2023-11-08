//
//  KeywordAppend.swift
//  PostKit
//
//  Created by 김다빈 on 11/2/23.
//

import SwiftUI

struct KeywordAppend: View {
    @Binding var isModalToggle: Bool
    @Binding var selectKeyWords: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Text("키워드")
                    .font(.body1Bold())
                    .foregroundColor(Color.gray5)
                Text("\(selectKeyWords.count)/5")
                    .body2Bold(textColor: .gray4)
                
                Spacer()
                
                Button(action: {
                    isModalToggle.toggle()
                    
                }, label: {
                    Text("+ 추가")
                        .body1Bold(textColor: .main)
                })
            }
    
            if !selectKeyWords.isEmpty {
                WrappingHStack(alignment: .leading) {
                    ForEach(selectKeyWords, id: \.self) { index in
                        CustomHashtag(tagText: index) {
                            selectKeyWords.removeAll(where: { $0 == index})
                        }
                    }
                }
            }
        }
    }
}
//#Preview {
//    KeywordAppend(selectKeyWords: .constant(["ds"]))
//}
