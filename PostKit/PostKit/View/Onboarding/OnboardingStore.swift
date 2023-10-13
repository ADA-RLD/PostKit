//
//  OnboardingStore.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingStore: View {
    @EnvironmentObject var appstorageManager: AppstorageManager
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    
    var body: some View {
        VStack {
            OnboardingCustomHeader(action: {onboardingRouter.previousPage()})
            VStack(alignment: .leading) {
                Text("매장의 이름을 알려주세요")
                    .font(.title1())
                Text("매장에 더 잘 맞는 커피가 생성됩니다.")
                    .font(.body2Bold())
                    .foregroundStyle(Color.gray)
                    .padding(.top,12)
                CustomTextfield(menuName: appstorageManager.$cafeName, placeHolder: "동글이 카페")
                CustomBasicBtn(btnDescription: "다음", action: {onboardingRouter.nextPage()})
            }
            .padding(.horizontal,paddingHorizontal)
        }
            
        }
       
}

#Preview {
    OnboardingStore(onboardingRouter: OnboardingRouter.shared)
}
