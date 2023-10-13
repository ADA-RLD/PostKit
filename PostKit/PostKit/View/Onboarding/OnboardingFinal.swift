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
            OnboardingCustomHeader(action: onboardingRouter.previousPage)
            VStack(alignment:.leading) {
                Text("\(appstorageManager.cafeName) 사장님,\n반가워요👋")
                    .font(.title1())
                Text("포스트킷과 함께\n카페 이야기를 적어내려가 봐요")
                    .font(.body1Bold())
                    .foregroundStyle(Color.gray4)
                    .padding(.top,40)
                CustomBasicBtn(btnDescription:"확인", action: {isFirstLaunching.toggle()})
            }
            .padding(.horizontal,paddingHorizontal)
        }
    }
}

#Preview {
    OnboardingFinal(onboardingRouter: OnboardingRouter.shared, isFirstLaunching: .constant(true))
}
