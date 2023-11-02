//
//  KeywordAppend.swift
//  PostKit
//
//  Created by 김다빈 on 11/2/23.
//

import SwiftUI

struct KeywordAppend: View {
//    @Binding private var isModalToggle: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius:radius1)
            .stroke(Color.gray2)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .foregroundColor(Color.white)
            .frame(height: 60)
            .overlay {
                HStack {
                    
                    Text("키워드")
                        .font(.body1Bold())
                        .foregroundColor(Color.gray5)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Text("+ 추가")
                            .font(.body1Bold())
                            .foregroundColor(Color.gray5)
                    })
                    
                }
                .padding(.all,20)
            }
    }
}

#Preview {
    KeywordAppend()
}
