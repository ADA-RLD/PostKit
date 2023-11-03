//
//  OnboardingTone.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingTone: View {
    
    @State var isActive: Bool = false
    //Core Data 저장을 위해 가지고 나가기
    @Binding var cafeTone : [String]
    
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    
    var body: some View {
        VStack(alignment:.leading,spacing: 0) {
            OnboardingCustomHeader(action: onboardingRouter.previousPage)
            ScrollView {
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
                            .onChange(of: cafeTone) { _ in
                                isActiveCheck()
                            }
                    }
                }
            }
            Spacer()

            CTABtn(btnLabel: "다음", isActive: $isActive, action: {onboardingRouter.nextPage()})
        }
    }
}

extension OnboardingTone {
    private func isActiveCheck() {
        if cafeTone .isEmpty {
            isActive = false
        }
        else {
            isActive = true
        }
    }
}
