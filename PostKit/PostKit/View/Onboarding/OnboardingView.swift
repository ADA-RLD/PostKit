//
//  OnboardingView.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI
import CoreData

struct OnboardingView: View {
    @EnvironmentObject var appstorageManager: AppstorageManager
    @StateObject var onboardingRouter = OnboardingRouter.shared
    @Binding var isFirstLaunching: Bool

    //CoreData Manager
    let storeDataManager = StoreDataManager.instance
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    var body: some View {
        VStack {
            if onboardingRouter.currentPage == 0 {
                OnboardingIntro()
            } else if onboardingRouter.currentPage == 1 {
            OnboardingStore(cafeName: $storeModel.storeName)
            } else if onboardingRouter.currentPage == 2 {
                OnboardingTone(cafeTone: $storeModel.tone)
            } else if onboardingRouter.currentPage == 3 {
                OnboardingFinal(isFirstLaunching: $isFirstLaunching)
            }
        }
        .onAppear{
            fetchStoreData()
        }
        .onChange(of: isFirstLaunching) { _ in
            saveStoreData()
        }
        .onChange(of: onboardingRouter.currentPage){
            print("데이터 변경\nStoreName: \(storeModel.storeName ?? "지정 안됨")\nStoreTone: \(storeModel.tone)")
        }
    }
}

extension OnboardingView : StoreProtocol {
    
    func saveStoreData() {
        self.storeDataManager.save()
        print("Store 저장 완료!\nStoreName: \(storeModel.storeName ?? "지정 안됨")\nStoreTone: \(storeModel.tone)")
    }
    
    func fetchStoreData() {
        let storeRequest = NSFetchRequest<StoreData>(entityName: "StoreData")
        
        do {
            let storeDataArray = try storeDataManager.context.fetch(storeRequest)
            if let storeCoreData = storeDataArray.first {
                self.storeModel.storeName = storeCoreData.storeName ?? ""
                self.storeModel.tone = storeCoreData.tone ?? ""
                
                print("Store Fetch 완료!\nStoreName: \(storeModel.storeName ?? "지정 안됨")\nStoreTone: \(storeModel.tone)")
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func deletStoreData() {
        print("delet")
    }

}
