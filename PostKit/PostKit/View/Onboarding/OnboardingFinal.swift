//
//  OnboardingFinal.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingFinal: View {
    @EnvironmentObject var appstorageManager: AppstorageManager
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    @Binding var isFirstLaunching: Bool
    var body: some View {
        VStack(alignment:.leading,spacing: 0) {
            OnboardingCustomHeader(action: onboardingRouter.previousPage)
            ContentArea {
                VStack(alignment:.leading,spacing: 40) {
                    Text("\(appstorageManager.cafeName) 사장님,\n반가워요👋")
                        .font(.title1())
                        .foregroundStyle(Color.gray6)
                    Text("포스트킷과 함께\n카페 이야기를 적어내려가 봐요")
                        .font(.body1Bold())
                        .foregroundStyle(Color.gray4)
                }
            }
            .padding(.top,paddingTop)
            Spacer()
            CtaBtn(btnDescription:"확인", isActive: .constant(true), action: {isFirstLaunching.toggle()})
        }
    }
}

#Preview {
    OnboardingFinal(onboardingRouter: OnboardingRouter.shared, isFirstLaunching: .constant(true))
}
