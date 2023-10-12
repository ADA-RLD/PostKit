//
//  OnboardingTone.swift
//  PostKit
//
//  Created by 김다빈 on 10/12/23.
//

import SwiftUI

struct OnboardingTone: View {
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    @State private var tone: String = "기본"
    var body: some View {
        VStack {
            OnboardingCustomHeader(action: onboardingRouter.previousPage)
            VStack(alignment: .leading) {
                Text("원하는 톤을 선택하세요")
                    .font(.title1())
                Text("선택한 톤을 바탕으로 카피가 생성됩니다.")
                    .font(.body2Bold())
                    .padding(.top,12)
                SelectTone(tone: self.$tone)
                CustomBasicBtn(btnDescription: "다음", action: {onboardingRouter.nextPage()})
                
            }
            .padding(.horizontal,paddingHorizontal)
            
        }
       
    }
}

