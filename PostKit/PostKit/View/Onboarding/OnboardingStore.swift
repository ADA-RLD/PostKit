//
//  OnboardingStore.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI
import Mixpanel

struct OnboardingStore: View {
    //Core Data 저장을 위해 가지고 나가기
    @Binding var cafeName : String
    @State private var isActive: Bool = false
    
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingCustomHeader(action: onboardingRouter.previousPage)
            ContentArea {
                VStack(alignment:.leading, spacing: 40) {
                    Text("매장의 이름을 알려주세요")
                        .title1(textColor: .gray6)
                    
                    VStack(alignment: .leading) {
                        CustomTextfield(text: $cafeName, placeHolder: "카페 포스트킷")
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
                   action: {
                hideKeyboard()
                if cafeName == "TEST" {
                    Mixpanel.mainInstance().people.set(properties: ["UserType": "Test", "$name": "\(cafeName)"])
                } else {
                    Mixpanel.mainInstance().people.set(properties: ["UserType": "Real", "$name": "\(cafeName)"])
                }
                onboardingRouter.nextPage()
            })
        }
        .onAppear {
            if !cafeName.isEmpty {
                isActive = true
            }
        }
    }
}
