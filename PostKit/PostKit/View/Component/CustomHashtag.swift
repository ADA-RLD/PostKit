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
            HStack {
                Text(tagText)
                    .font(.body2Regular())
                    .foregroundColor(.main)
                Image(systemName: "xmark")
                    .font(.body2Regular())
                    .foregroundColor(.main)
                    .onTapGesture {
                        deleteAction()
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.sub)
            .clipShape(RoundedRectangle(cornerRadius: radius1))
            .overlay {
                RoundedRectangle(cornerRadius: radius1)
                    .stroke(Color.main,lineWidth: 2)
            }
        }
    }


#Preview {
    CustomHashtag(tagText: "hi") {
        print("hello")
    }
}
