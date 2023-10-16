//
//  OnboardingTone.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingTone: View {
    @EnvironmentObject var appstorageManager: AppstorageManager
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    
    var body: some View {
        VStack {
            VStack {
                OnboardingCustomHeader(action: onboardingRouter.previousPage)
                    .padding(.vertical,18)
                    .padding(.horizontal,16)
                // TODO: padding값이 헤더값은 다른데 나중에 해두겠습니다.
                VStack(alignment: .leading) {
                    Text("원하는 톤을 선택하세요")
                        .font(.title1())
                        .padding(.top,20)
                    Text("선택한 톤을 바탕으로 카피가 생성됩니다.")
                        .font(.body2Bold())
                        .padding(.top,12)
                    SelectTone(tone: appstorageManager.$cafeTone)
                        .padding(.top,40)
                    Spacer()
                    CustomBasicBtn(btnDescription: "다음", action: {onboardingRouter.nextPage()})
                }
                .padding(.horizontal,paddingHorizontal)
            }
        }
    }
}
