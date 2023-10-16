//
//  OnboardingStore.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingStore: View {
    //@EnvironmentObject var appstorageManager: AppstorageManager
    
    //Core Data 저장을 위해 가지고 나가기
    @Binding var cafeName : String
    
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    @State private var isActive: Bool = false
    var body: some View {
        VStack {
            OnboardingCustomHeader(action: {onboardingRouter.previousPage()})
                .padding(.horizontal,16)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("매장의 이름을 알려주세요")
                        .font(.title1())
                        .foregroundStyle(Color.gray6)
                        .padding(.top,20)
                    Text("매장에 더 잘 맞는 커피가 생성됩니다.")
                        .font(.body2Bold())
                        .foregroundStyle(Color.gray4)
                        .padding(.top,12)
                    CustomTextfield(textLimit: 15, menuName: $cafeName, placeHolder: "동글이 카페")
                        .padding(.top,40)
                    // cafeName이 비어있지 않으면 트루 OR false
                        .onChange(of: $cafeName.wrappedValue) { lengthCount in
                            if !lengthCount.isEmpty {
                                isActive = true
                            } else {
                                isActive = false
                            }
                        }
                }
                .padding(.top,20)
                .padding(.bottom,80)
                Spacer()
                CustomBtn(btnDescription: "다음", isActive: $isActive, action: {onboardingRouter.nextPage()
                print("\(cafeName)")})
            }
            .padding(.horizontal,paddingHorizontal)
        }
    }
}

//#Preview {
//    OnboardingStore(onboardingRouter: OnboardingRouter.shared)
//}
