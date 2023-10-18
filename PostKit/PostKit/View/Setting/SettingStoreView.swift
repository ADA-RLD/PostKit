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
    let storeDataManager = StoreDataManager.instance
    
    //CoreData Data Class
    @Binding var storeName: String
    @State var storeTone: String = ""
    
    var body: some View {
        VStack {
            CustomHeader(action: {pathManager.path.removeLast()}, title: "매장 정보")
            VStack(alignment: .leading, spacing: 0) {
                Text("이름")
                    .font(.body1Bold())
                    .foregroundStyle(Color.gray5)
                CustomTextfield(textLimit: 15, menuName: $storeName, placeHolder: storeName)
                    .padding(.top,12)
                Spacer()
                CtaBtn(btnLabel: "저장", isActive: .constant(true), action: {
                    saveStoreData(storeName: storeName, storeTone: storeTone)
                    pathManager.path.removeLast()
                })
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal,paddingHorizontal)
        }
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
                storeTone = storeCoreData.tone ?? ""
                
                print("Store Fetch 완료!\nStoreTone: \(storeTone)\n")
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func saveStoreData(storeName: String, storeTone: String) {
        
        guard !storeName.isEmpty else { return }
        let newStore = StoreData(context: storeDataManager.context)
        newStore.storeName = storeName
        newStore.tone = storeTone
        print("StoreData: \(newStore)")
        storeDataManager.save()
        
        print("Store 저장 완료!\nStoreName: \(newStore.storeName ?? "지정 안됨")\nStoreTone: \(newStore.tone)\n")
        
    }
}

