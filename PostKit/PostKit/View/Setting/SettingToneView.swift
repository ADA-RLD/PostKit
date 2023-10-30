//
//  SettingToneView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//


import SwiftUI
import CoreData

struct SettingToneView: View {
    @EnvironmentObject var pathManager: PathManager
    //@EnvironmentObject var appstorageManager: AppstorageManager
   
    //CoreData Manager
    let storeDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @State var storeName: String = ""
    @Binding var storeTone: [String]
    
    
    var body: some View {
        VStack(alignment:.leading,spacing: 0) {
            CustomHeader(action: {
                pathManager.path.removeLast()
            }, title: "말투")
            ContentArea {
                VStack(spacing: 0) {
                    SelectTone(selectedTones: $storeTone)
                }
            }
            Spacer()
            CTABtn(btnLabel: "저장", isActive: .constant(true)) {
                //TODO: coredata 형식 변경 필요
//                saveStoreData(storeName: storeName, storeTone: storeTone)
                pathManager.path.removeLast()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{fetchStoreData()}
    }
}

extension SettingToneView {
    private var toggleBtns: some View {
        SelectTone(selectedTones: $storeTone)
    }
}

private func toggleBtn(answer: String) -> some View {
    Button {
        
    } label: {
        RoundedRectangle(cornerRadius: 16)
            .overlay {
                Text(answer)
            }
    }
}

extension SettingToneView: SettingProtocol {
    func fetchStoreData() {
        let storeRequest = NSFetchRequest<StoreData>(entityName: "StoreData")
        
        do {
            let storeDataArray = try storeDataManager.context.fetch(storeRequest)
            print("StoreData: \(storeDataArray)")
            if let storeCoreData = storeDataArray.last {
                storeName = storeCoreData.storeName ?? ""
                
                print("Store Fetch 완료!\nStoreName: \(storeName)\n")
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
        newStore.tone1 = storeTone[0]
        newStore.tone2 = storeTone[1]
        newStore.tone3 = storeTone[2]
        print("StoreData: \(newStore)")
        storeDataManager.save()
        
        print("Store 저장 완료!\nStoreName: \(newStore.storeName ?? "지정 안됨")\nStoreTone: \(newStore.tone1)\n")
        
    }
    

}
