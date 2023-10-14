//
//  OnboardingIntro.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingIntro: View {
    @EnvironmentObject var appstorageManager: AppstorageManager
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading,spacing: 30) {
                Text("포스트킷과 함께\n우리 매장을 알려봐요")
                    .font(.title1())
                    .foregroundStyle(Color.gray6)
                Text("포스트킷은 쉽고 빠르게 마케팅용 콘텐츠를 생성하는\n효과적인 인공지능 글쓰기 도구입니다.\n\n몇 번의 탭만으로\n생성하고 싶은 주제 대한 정보를 선택하고\n귀찮은 콘텐츠 생성 업무를 해결해보세요!")
                    .font(.body1Bold())
                    .foregroundStyle(Color.gray4)
            }
            .padding(.top,120)
            Spacer()

            VStack() {
                CustomBtn(btnDescription: "시작하기", isActive: .constant(true), action: {onboardingRouter.nextPage();print(onboardingRouter.currentPage)})
            }
            .frame(alignment: .bottom)
        }
        .onAppear {
            appstorageManager.$cafeName.wrappedValue = ""
            appstorageManager.$cafeTone.wrappedValue = "기본"
        }
        .padding(.horizontal,paddingHorizontal)
    }
}

#Preview {
    OnboardingIntro(onboardingRouter: OnboardingRouter.shared)
}
