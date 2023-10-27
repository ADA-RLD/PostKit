//
//  OnboardingTone.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingTone: View {
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    
    //Core Data 저장을 위해 가지고 나가기
    @Binding var cafeTone : [String]
    
    var body: some View {
        VStack(alignment:.leading,spacing: 0) {
            OnboardingCustomHeader(action: onboardingRouter.previousPage)
            ContentArea {
                VStack(alignment: .leading,spacing: 40) {
                    VStack(alignment: .leading,spacing: 12) {
                        Text("원하는 톤을 선택하세요")
                            .font(.title1())
                            .foregroundStyle(Color.gray6)
                        Text("선택한 톤을 바탕으로 카피가 생성됩니다.")
                            .font(.body2Bold())
                            .foregroundStyle(Color.gray4)
                    }
                    SelectTone(selectedTones: $cafeTone)
                }
            }
            
            Spacer()

            CTABtn(btnLabel: "다음", isActive: .constant(true), action: {print(cafeTone);onboardingRouter.nextPage()})
        }
    }
}
