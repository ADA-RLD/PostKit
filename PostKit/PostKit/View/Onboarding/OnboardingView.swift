//
//  OnboardingView.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI
import CoreData

struct OnboardingView: View {
    @StateObject var onboardingRouter = OnboardingRouter.shared
    @Binding var isFirstLaunching: Bool

    //CoreData Manager
    let coreDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel


    //CoreData 초기화
    //혹시 모르는 잘못된 값을 위해 초기화
    init(isFirstLaunching: Binding<Bool>, storeModel: StoreModel) {
           self._isFirstLaunching = isFirstLaunching
           self._storeModel = StateObject(wrappedValue: storeModel)
           fetchStoreData()
       }
    
    var body: some View {
        VStack {
            //onBoarding의 순서를 관리합니다.
            //데이터 관리는 해당 위치에서 하기때문에 Binding으로 접근합니다.
            switch onboardingRouter.currentPage {
                case 0:
                    OnboardingIntro()
                    .onAppear{fetchStoreData()}
                case 1:
                    OnboardingStore(cafeName: $storeModel.storeName)
                case 2:
                    OnboardingTone(cafeTone: $storeModel.tone)
                case 3:
                    OnboardingFinal(isFirstLaunching: $isFirstLaunching, storeName: $storeModel.storeName)
            default:
                OnboardingFinal(isFirstLaunching: $isFirstLaunching, storeName: $storeModel.storeName)
            }
        }
        //마지막 뷰에 도착하면 CoreData에 가게 정보를 저장합니다.
        .onChange(of: onboardingRouter.currentPage == 3) { _ in
            saveStoreData(storeName: storeModel.storeName, storeTone: storeModel.tone)
        }
    }
}

extension OnboardingView : StoreProtocol {
    
    func saveStoreData(storeName: String, storeTone: Array<String>) {
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
                self.storeModel.tone = []
                
                print("Onboarding Fetch 완료!\nStoreName: \(storeModel.storeName ?? "지정 안됨")\nStoreTone: \(storeModel.tone)\n")
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
    }
}
