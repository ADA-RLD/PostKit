//
//  CustomToast.swift
//  PostKit
//
//  Created by 신서연 on 2023/11/06.
//

import SwiftUI

struct CustomToast: View {
    var body: some View {
                VStack{
                    Spacer()
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.yellow)
                        Text("클립보드에 복사되었습니다!")
                            .body1Bold(textColor: .white)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(.gray5)
                        .cornerRadius(radius1)
                        .padding(.horizontal, paddingHorizontal)
                        .padding(.bottom, paddingBottom)
                }
    }
}

#Preview {
    CustomToast()
}
