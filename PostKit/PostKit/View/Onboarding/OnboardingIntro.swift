//
//  OnboardingIntro.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingIntro: View {
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            ContentArea {
                VStack(alignment: .leading, spacing: 30) {
                    Image(.onboardingStart)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 113)
                    
                    Text("포스트킷과 함께\n우리 매장을 알려봐요")
                        .title1(textColor: .gray6)
                    
                    Text("포스트킷은 쉽고 빠르게 마케팅용 콘텐츠를 생성하는\n효과적인 인공지능 글쓰기 도구에요.\n\n몇 번의 탭만으로\n귀찮은 콘텐츠 제작 업무를 해결해보세요!")
                        .body1Regular(textColor: .gray4)
                }
            }
            .padding(.top, 80)
            
            Spacer()
            
            CTABtn(btnLabel: "시작", isActive: .constant(true), action: {
                onboardingRouter.nextPage()
                print(onboardingRouter.currentPage)
            })
        }
    }
}

#Preview {
    OnboardingIntro(onboardingRouter: OnboardingRouter.shared)
}
