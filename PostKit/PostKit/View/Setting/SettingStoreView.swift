//
//  SettingStoreView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI
import CoreData

struct SettingStoreView: View {
    @EnvironmentObject var pathManager: PathManager
    @EnvironmentObject var appstorageManager: AppstorageManager
    
    //CoreData Manager
    let storeDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @Binding var storeName: String
    @State var storeTone: Array = ["","",""]
    @State var isActive: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            CustomHeader(action: {pathManager.path.removeLast()}, title: "매장 정보")
            ContentArea{
                VStack(alignment: .leading, spacing: 12) {
                    Text("이름")
                        .font(.body1Bold())
                        .foregroundStyle(Color.gray5)
                    CustomTextfield(text: $storeName, placeHolder: storeName)
                        .onChange(of: $storeName.wrappedValue) { lengthCount in
                            if !lengthCount.isEmpty {
                                isActive = true
                            } else {
                                isActive = false
                            }
                        }
                }
            }
            Spacer()
            CTABtn(btnLabel: "저장", isActive: $isActive, action: {
                saveStoreData(storeName: storeName, storeTone: storeTone)
                pathManager.path.removeLast()
            })
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{fetchStoreData()}
    }
}

extension SettingStoreView : SettingProtocol {
    func fetchStoreData() {
        let storeRequest = NSFetchRequest<StoreData>(entityName: "StoreData")
        
        do {
            let storeDataArray = try storeDataManager.context.fetch(storeRequest)
            print("StoreData: \(storeDataArray)")
            if let storeCoreData = storeDataArray.last {
                storeTone = storeCoreData.tones ?? ["기본"]
                
                print("Store Fetch 완료!\nStoreTone: \(storeTone)\n")
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func saveStoreData(storeName: String, storeTone: Array<String>) {
        
        guard !storeName.isEmpty else { return }
        let newStore = StoreData(context: storeDataManager.context)
        newStore.storeName = storeName
        newStore.tones = storeTone
        print("StoreData: \(newStore)")
        storeDataManager.save()
        
        print("Store 저장 완료!\nStoreName: \(newStore.storeName ?? "지정 안됨")\nStoreTone: \(newStore.tones)\n")
        
    }
}

