//
//  OnboardingView.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var onboardingRouter = OnboardingRouter.shared
    @Binding var isFirstLaunching: Bool

    var body: some View {
        VStack {
            if onboardingRouter.currentPage == 0 {
                OnboardingIntro()
            } else if onboardingRouter.currentPage == 1 {
                OnboardingStore()
            } else if onboardingRouter.currentPage == 2 {
                OnboardingTone()
            } else if onboardingRouter.currentPage == 3 {
                OnboardingFinal(isFirstLaunching: $isFirstLaunching)
            }
        }
    }
}
