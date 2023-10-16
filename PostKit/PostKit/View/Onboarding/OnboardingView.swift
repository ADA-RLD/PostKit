//
//  OnboardingView.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appstorageManager: AppstorageManager
    @StateObject var onboardingRouter = OnboardingRouter.shared
    @Binding var isFirstLaunching: Bool

    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    var body: some View {
        VStack {
            if onboardingRouter.currentPage == 0 {
                OnboardingIntro()
            } else if onboardingRouter.currentPage == 1 {
                OnboardingStore(cafeName: storeModel.storeName ?? "")
            } else if onboardingRouter.currentPage == 2 {
                OnboardingTone()
            } else if onboardingRouter.currentPage == 3 {
                OnboardingFinal(isFirstLaunching: $isFirstLaunching)
            }
        }
    }
}

//extension OnboardingView : StoreProtocol {
//    func saveStoreData(storeName: String?, tone: String) {
//        <#code#>
//    }
//    
//    func fetchStoreData(storeName: String, tone: String) {
//        <#code#>
//    }
//    
//    func deletStoreData() {
//        <#code#>
//    }
//    
//    
//}
