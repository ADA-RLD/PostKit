//
//  OnboardingTone.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingTone: View {
    
    @State var isActive: Bool = false
    @State var isShowToast: Bool = false
    //Core Data 저장을 위해 가지고 나가기
    @Binding var cafeTone : [String]
    
    @ObservedObject var onboardingRouter = OnboardingRouter.shared
    
    var body: some View {
        ZStack{
            VStack(alignment:.leading,spacing: 0) {
                OnboardingCustomHeader(action: onboardingRouter.previousPage)
                ScrollView {
                    ContentArea {
                        VStack(alignment: .leading,spacing: 40) {
                            VStack(alignment: .leading,spacing: 12) {
                                Text("어떤 말투로 글을 쓸까요?")
                                    .title1(textColor: .gray6)

                                Text("최대 3개까지 선택할 수 있어요")
                                    .body2Bold(textColor: .gray4)
                            }
                            
                            SelectTone(selectedTones: $cafeTone, isShowToast: $isShowToast)
                                .onChange(of: cafeTone) { _ in
                                    isActiveCheck()
                                }
                        }
                    }
                }
            }
            .toast(toastText: "3개까지 추가할 수 있어요", toastImgRes: Image(.exclamation), isShowing: $isShowToast)
            
            Group{
                CTABtn(btnLabel: "다음", isActive: $isActive, action: {onboardingRouter.nextPage()})
                .background(Color.white)
            }.frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear{cafeTone.removeAll()}
    }
}

extension OnboardingTone {
    private func isActiveCheck() {
        if cafeTone.isEmpty {
            isActive = false
        }
        else {
            isActive = true
        }
    }
}
