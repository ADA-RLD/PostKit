//
//  CustomVstack.swift
//  PostKit
//
//  Created by 김다빈 on 10/18/23.
//

import SwiftUI

//MARK: Padding값을 미리 적용해서 ContentArea라는 ViewBuilder를 만들어서 이제 따로 전체 패딩값을 주지 않아도 됩니다.
struct ContentArea<T: View>: View {
    let content: T
    
    init(@ViewBuilder content: () -> T) {
           self.content = content()
       }
    
    var body: some View {
            content
                .padding(.horizontal,paddingHorizontal)
                .padding(.top,paddingTop)
                .padding(.bottom,paddingBottom)

    }
}

//MARK: CustomVstack을 활용한 뷰 예시
/*
struct SampleView: View {
    var body: some View {
        VStack {
            ContentArea {
                VStack(spacing:40) {
                    Rectangle()
                        .frame(height: 30)
                    Rectangle()
                        .frame(height: 30)
                    
                }
                .border(.blue)
            }
            .border(.red)
            CtaBtn(btnDescription: "dd", isActive: .constant(true), action: {print("")})
        }
    }
}

#Preview {
    SampleView()
}
*/
