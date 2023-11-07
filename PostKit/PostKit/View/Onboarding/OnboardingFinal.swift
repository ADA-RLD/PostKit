//
//  OnboardingFinal.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI
import Mixpanel
import AppTrackingTransparency

struct OnboardingFinal: View {
    @Binding var isFirstLaunching: Bool
    
    //Core Data 저장을 위해 가지고 나가기
    @Binding var storeName : String
    
    @ObservedObject var onboardingRouter = OnboardingRouter.shared

    var body: some View {
        VStack(alignment:.leading,spacing: 0) {
            OnboardingCustomHeader(action: onboardingRouter.previousPage)
            ContentArea {
                VStack(alignment:.leading,spacing: 30) {
                    Image(.onboardingFinal)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 125)
                    
                    Text("\(storeName) 사장님,\n반가워요")
                        .title1(textColor: .gray6)

                    
                    Text("포스트킷과 함께\n카페 이야기를 적어내려가봐요")
                        .body1Regular(textColor: .gray4)
                }
            }
            Spacer()
            CTABtn(btnLabel:"확인", isActive: .constant(true), action: {isFirstLaunching.toggle()
                Mixpanel.mainInstance().setGroup(groupKey: "RealUser", groupID: "AfterOnboardingGroup")

                
            })
        }

    }
}

