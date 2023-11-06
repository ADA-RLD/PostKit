//
//  LoadingCancelView.swift
//  PostKit
//
//  Created by Kim Andrew on 11/6/23.
//

import SwiftUI

struct LoadingCancelView: View {
    var body: some View {
        ContentArea {
            VStack(alignment: .center, spacing: 8){
                Text("생성을 취소할까요?")
                    .font(.body1Bold())
                    .foregroundColor(.gray6)
                
                Text("취소하더라도 1 크레딧이 사용돼요")
                
                ZStack{
                    Rectangle()
                        .cornerRadius(radius2)
                        .foregroundColor(.gray5)
                        .padding(.horizontal, 100)
                        .padding(.vertical, 20)
                    
                    Text("취소")
                        .font(.body2Bold())
                        .foregroundColor(.white)
                }
                
                Text("계속 생성")
                
            }
            .frame(width: 280,height: 280)
            .padding(.vertical, 48)
        }
    }
}

#Preview {
    LoadingCancelView()
}
