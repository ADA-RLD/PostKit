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
            OnboardingCustomHeader(action: onboardingRouter.previousPage)
                .padding(.horizontal,16)
            VStack {
                VStack(alignment: .leading) {
                    Text("원하는 톤을 선택하세요")
                        .font(.title1())
                        .foregroundStyle(Color.gray6)
                        .padding(.top,20)
                    Text("선택한 톤을 바탕으로 카피가 생성됩니다.")
                        .font(.body2Bold())
                        .foregroundStyle(Color.gray4)
                        .padding(.top,12)
                    SelectTone(tone: appstorageManager.$cafeTone)
                        .padding(.top,40)
                    Spacer()
                    CustomBtn(btnDescription: "다음", isActive: .constant(true), action: {onboardingRouter.nextPage()})
                }
                .padding(.horizontal,paddingHorizontal)
            }
        }
    }
}
