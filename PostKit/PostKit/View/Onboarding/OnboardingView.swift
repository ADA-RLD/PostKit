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
    let coreDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel


    //CoreData 초기화
    init(isFirstLaunching: Binding<Bool>, storeModel: StoreModel) {
           self._isFirstLaunching = isFirstLaunching
           self._storeModel = StateObject(wrappedValue: storeModel)
           fetchStoreData()
       }
    
    var body: some View {
        VStack {
            if onboardingRouter.currentPage == 0 {
                OnboardingIntro()
            } else if onboardingRouter.currentPage == 1 {
            OnboardingStore(cafeName: $storeModel.storeName)
            } else if onboardingRouter.currentPage == 2 {
                OnboardingTone(cafeTone: $storeModel.tone)
            } else if onboardingRouter.currentPage == 3 {
                OnboardingFinal(isFirstLaunching: $isFirstLaunching, storeName: $storeModel.storeName)
            }
        }
        .onAppear{
            fetchStoreData()
        }
        .onChange(of: onboardingRouter.currentPage == 3) { _ in
            //TODO: 코어데이터 함수 변경 필요
            saveStoreData(storeName: storeModel.storeName, storeTone: storeModel.tone)
        }
    }
}

extension OnboardingView : StoreProtocol {
    
    func saveStoreData(storeName: String, storeTone: Array<String>) {
        print("\(storeName), \(storeTone)")
        guard !storeName.isEmpty else { return }
        let newStore = StoreData(context: coreDataManager.context)
        newStore.storeName = storeName
        newStore.tones = storeTone
        print("StoreData: \(newStore)")
        coreDataManager.save()
        
        print("Onboarding 저장 완료!\nStoreName: \(newStore.storeName ?? "지정 안됨")\nStoreTone: \(newStore.tones)\n")
    }
    
    func fetchStoreData() {
        let storeRequest = NSFetchRequest<StoreData>(entityName: "StoreData")
        
        do {
            let storeDataArray = try coreDataManager.context.fetch(storeRequest)
            print("StoreData: \(storeDataArray)")
            if let storeCoreData = storeDataArray.last {
                self.storeModel.storeName = storeCoreData.storeName ?? ""
                self.storeModel.tone = ["기본"]
                
                print("Onboarding Fetch 완료!\nStoreName: \(storeModel.storeName ?? "지정 안됨")\nStoreTone: \(storeModel.tone)\n")
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
