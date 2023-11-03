//
//  OnboardingStore.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingStore: View {
    //Core Data 저장을 위해 가지고 나가기
    @Binding var cafeName : String
    @State private var isActive: Bool = false
    
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingCustomHeader(action: {onboardingRouter.previousPage()})
            ContentArea {
                VStack(alignment:.leading,spacing: 40){
                    VStack(alignment:.leading, spacing: 12) {
                        Text("매장의 이름을 알려주세요")
                            .font(.title1())
                            .foregroundStyle(Color.gray6)
                        Text("매장에 더 잘 맞는 카피가 생성됩니다.")
                            .font(.body2Bold())
                            .foregroundStyle(Color.gray4)
                    }
                    VStack(alignment: .leading) {
                        CustomTextfield(text: $cafeName, placeHolder: "동글이 카페")
                            .onChange(of: $cafeName.wrappedValue) { lengthCount in
                                if !lengthCount.isEmpty {
                                    isActive = true
                                } else {
                                    isActive = false
                                }
                            }
                    }
                }
            }
            Spacer()
            CTABtn(btnLabel: "다음", isActive: $isActive,
                   action: {hideKeyboard()
                onboardingRouter.nextPage()
            })
        }
    }
}
