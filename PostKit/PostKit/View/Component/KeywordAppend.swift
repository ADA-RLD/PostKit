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
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 8) {
                Text("키워드")
                    .body1Bold(textColor: .gray5)
                
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
                WrappingHStack(alignment: .leading,horizontalSpacing: 8, verticalSpacing: 8) {
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
