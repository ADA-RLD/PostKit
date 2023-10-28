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
                    .foregroundStyle(.main)
                Image(systemName: "xmark")
                    .font(.body2Regular())
                    .foregroundStyle(.main)
                    .onTapGesture {
                        deleteAction()
                    }
            }
            .padding(EdgeInsets(top: 8, leading: radius1, bottom: 8, trailing: radius1))
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
