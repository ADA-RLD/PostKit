//
//  CustomHashtag.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/28.
//

import SwiftUI

struct CustomHashtag: View {
    let tagText: String
    let deleteAction: () -> Void
    
    var body: some View {
        HStack (spacing: 2) {
            Text(tagText)
                .body2Regular(textColor: .main)
            
            Image(.xMono)
                .font(.body2Regular())
                .foregroundColor(.main)
                .onTapGesture {
                    deleteAction()
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .cornerRadius(radius1)
        .background(Color.sub)
        .overlay (
            RoundedRectangle(cornerRadius: radius1)
                .stroke(Color.main, lineWidth: 2)
        )
    }
}


#Preview {
    CustomHashtag(tagText: "hi") {
        print("hello")
    }
}
