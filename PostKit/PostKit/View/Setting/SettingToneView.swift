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
    let storeDataManager = StoreDataManager.instance
    
    //CoreData Data Class
    @State var storeName: String = ""
    @Binding var storeTone: String
    
    var tones: [String] = ["기본","친구같은","전문적인","친절한","재치있는","열정적인","감성적인","활발한","세련된"]
    
    var body: some View {
        VStack(alignment:.leading) {
            CustomHeader(action: {
                pathManager.path.removeLast()
            }, title: "말투")
            VStack {
                toggleBtns
                Spacer()
                CtaBtn(btnDescription: "저장", isActive: .constant(true)) {
                    pathManager.path.removeLast()
                    saveStoreData(storeName: storeName, storeTone: storeTone)
                    pathManager.path.removeLast()
                }
            }
            .padding(.horizontal,paddingHorizontal)
            .padding(.top, paddingTop)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{fetchStoreData()}
    }
}

extension SettingToneView {
    private var toggleBtns: some View {
        SelectTone(tone: $storeTone)
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
