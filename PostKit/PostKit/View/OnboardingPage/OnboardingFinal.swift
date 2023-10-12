//
//  OnboardingFinal.swift
//  PostKit
//
//  Created by 김다빈 on 10/12/23.
//

import SwiftUI

struct OnboardingFinal: View {
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    @Binding var isFirstLaunching: Bool
    var body: some View {
        VStack(alignment:.leading) {
            Text("낭만 카페 사장님,\n반가워요👋")
            Text("포스트킷과 함께\n카페 이야기를 적어내려가 봐요")
                .font(.body1Bold())
                .foregroundStyle(Color.gray)
                .padding(.top,40)
            CustomBasicBtn(btnDescription:"확인", action: {isFirstLaunching.toggle()})
        }
        .padding(.horizontal,paddingHorizontal)
        
    }
}
