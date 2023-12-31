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
                    settingStoreInfo(info: "매장 정보", Answer: storeModel.storeName, action: {pathManager.path.append(.SettingStore)})
                    settingToneInfo(info: "말투", tones: storeModel.tone, action: {pathManager.path.append(.SettingTone)})
                    settingCS(info: "문의하기") {
                        pathManager.path.append(.SettingCS)
                    }
                }
            }
         
            Spacer()
        }
        .onAppear{fetchStoreData()}
        .navigationBarBackButtonHidden(true)
    }
}

private func settingStoreInfo(info: String, Answer: String?,action: @escaping () -> Void) -> some View {
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

private func settingCS(info: String, action: @escaping () -> Void) -> some View {
    HStack {
        Text(info)
            .font(.body1Bold())
            .foregroundColor(.gray5)
        
        Spacer()

        Button {
            action()
        } label: {
            Image(systemName: "chevron.right")
                .font(.body1Bold())
                .foregroundColor(.gray4)
        }
    }
}

private func settingToneInfo(info: String, tones: Array<String>?, action: @escaping () -> Void) -> some View {
    HStack {
        Text(info)
            .font(.body1Bold())
            .foregroundStyle(Color.gray5)
        Spacer()
        Button {
            action()
        } label: {
            HStack(spacing: 8.0) {
                Text((tones?.isEmpty ?? true ? "기본" : tones?.joined(separator: ", ")) ?? "기본")
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
            self.storeModel.tone = storeDataArray.last?.tones ?? []
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

