//
//  CustomVstack.swift
//  PostKit
//
//  Created by 김다빈 on 10/18/23.
//

import SwiftUI

//MARK: Padding값을 미리 적용해서 CustomVstack을 적용
struct CustomVstack<T: View>: View {
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

//CustomVstack을 활용한 뷰 예시
import SwiftUI

struct SampleView: View {
    var body: some View {
        VStack {
            CustomVstack {
                VStack() {
                    Rectangle()
                    
                }
            }
            CtaBtn(btnDescription: "dd", isActive: .constant(true), action: {print("")})
        }
    }
}

#Preview {
    SampleView()
}
