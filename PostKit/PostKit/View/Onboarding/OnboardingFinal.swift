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
        VStack {
            VStack {
                OnboardingCustomHeader(action: onboardingRouter.previousPage)
                    .padding(.horizontal,16)
            }
            VStack(alignment:.leading) {
                Text("\(appstorageManager.cafeName) 사장님,\n반가워요👋")
                    .font(.title1())
                    .foregroundStyle(Color.gray6)
                    .padding(.top,60)
                Text("포스트킷과 함께\n카페 이야기를 적어내려가 봐요")
                    .font(.body1Bold())
                    .foregroundStyle(Color.gray4)
                    .padding(.top,40)
                Spacer()
                CtaBtn(btnDescription:"확인", isActive: .constant(true), action: {isFirstLaunching.toggle()})
            }
            .padding(.horizontal,paddingHorizontal)
        }
    }
}

#Preview {
    OnboardingFinal(onboardingRouter: OnboardingRouter.shared, isFirstLaunching: .constant(true))
}
