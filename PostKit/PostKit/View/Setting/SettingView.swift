//
//  SettingView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI
import CoreData

struct SettingView: View {
    //@EnvironmentObject var appstorageManager: AppstorageManager
    @EnvironmentObject var pathManager: PathManager
    
    //CoreData Manager
    let storeDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    var name: String?
    var body: some View {
        VStack(spacing: 0) {
            CustomHeader(action: {
                pathManager.path.removeLast()
            }, title: "설정")
            ContentArea {
                VStack(spacing: 40.0) {
                    SettingInfo(info: "매장 정보", Answer: storeModel.storeName, action: {pathManager.path.append(.SettingStore)})
                    // TODO: 코어데이터 함수 변경 필요
//                    SettingInfo(info: "말투", Answer: storeModel.tone, action: {pathManager.path.append(.SettingTone)})
            
                }
            }
            Spacer()
        }
        .onAppear{fetchStoreData()}
        .navigationBarBackButtonHidden(true)
    }
}

private func SettingInfo(info: String, Answer: String?,action: @escaping () -> Void) -> some View {
    HStack {
        Text(info)
            .font(.body1Bold())
            .foregroundStyle(Color.gray5)
        Spacer()
        Button {
            action()
        } label: {
            HStack(spacing: 8.0) {
                Text(Answer ?? "미입력")
                Text(Image(systemName: "chevron.right"))
            }
            .font(.body1Bold())
            .foregroundStyle(Color.gray4)
        }
    }
}

extension SettingView: SettingProtocol {
    func fetchStoreData() {
        
        let storeRequest = NSFetchRequest<StoreData>(entityName: "StoreData")
        
        do {
            let storeDataArray = try storeDataManager.context.fetch(storeRequest)
            print("StoreData: \(storeDataArray)")
            self.storeModel.storeName = storeDataArray.last?.storeName ?? ""
            //TODO: CoreData 함수 변경 필요
            self.storeModel.tone[0] = storeDataArray.last?.tone1 ?? ""
            self.storeModel.tone[1] = storeDataArray.last?.tone2 ?? ""
            self.storeModel.tone[2] = storeDataArray.last?.tone3 ?? ""
            print("데이터 Fetch완료\nStoreData: \(storeModel.storeName)\nStoreTone: \(storeModel.tone)\n")
            
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func saveStoreData(storeName: String, storeTone: Array<String>) {
       print("필요 없어요~")
    }
}

