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
   
    //CoreData Manager
    let storeDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @State var storeName: String = ""
    @State var isActive: Bool = false
    @State var isShowToast: Bool = false
    @Binding var storeTone: [String]
    
    
    var body: some View {
        ZStack{
            VStack(alignment:.leading, spacing: 0) {
                CustomHeader(action: {
                    pathManager.path.removeLast()
                }, title: "말투")
                
                ScrollView {
                    ContentArea {
                        VStack(spacing: 0){
                            HStack(spacing: 0){
                                Text("최대 3개까지 선택할 수 있어요")
                                    .body2Bold(textColor: .gray4)
                                    .padding(.bottom, 16)
                                Spacer()
                            }
                            
                            VStack(spacing: 0) {
                                SelectTone(selectedTones: $storeTone, isShowToast: $isShowToast)
                                    .onChange(of: storeTone) { _ in
                                        isActiveCheck()
                                    }
                            }
                        }
                    }
                }
            }
            .toast(toastText: "3개까지 추가할 수 있어요", toastImgRes: Image(.exclamation), isShowing: $isShowToast)
            
            Group{
                CTABtn(btnLabel: "저장", isActive: $isActive) {
                    //TODO: coredata 형식 변경 필요
                    saveStoreData(storeName: storeName, storeTone: storeTone)
                    pathManager.path.removeLast()
                }
                .background(Color.white)
            }.frame(maxHeight: .infinity, alignment: .bottom)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchStoreData()
            isActiveCheck()
        }
    }
}

extension SettingToneView {
    private var toggleBtns: some View {
        SelectTone(selectedTones: $storeTone, isShowToast: $isShowToast)
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

// MARK: 함수를 관리하는 익스텐션입니다.
extension SettingToneView {
    
    //MARK: 버튼 활성화 체크하는 함수
    private func isActiveCheck() {
        if storeTone.isEmpty {
            isActive = false
        }
        else if storeTone.count > 0 {
            isActive = true
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
        newStore.tones = storeTone
        print("StoreData: \(newStore)")
        storeDataManager.save()
        
        print("Store 저장 완료!\nStoreName: \(newStore.storeName ?? "지정 안됨")\nStoreTone: \(newStore.tones)\n")
        
    }
    

}
