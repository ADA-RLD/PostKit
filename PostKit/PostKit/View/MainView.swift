//
//  MainView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI
import CoreData

struct MainView: View {
    @AppStorage("_cafeName") var cafeName: String = ""
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @EnvironmentObject var appstorageManager: AppstorageManager
    @EnvironmentObject var pathManager: PathManager
    @ObservedObject var viewModel = ChatGptViewModel.shared
    
    let storeDataManager = StoreDataManager.instance
    
    //CoreData Data 임시 Class
    @StateObject var storeModel = StoreModel( _tone: "")
    @StateObject var menuModel = MenuModel(_storeName: "", _storeTone: "", _menuName: "", _menuPoint: "", _recordResult: "")
    @StateObject var dailyModel = DailyModel(_storeName: "", _storeTone: "", _recordResult: "")
    
    
    var body: some View {
        NavigationStack(path: $pathManager.path) {
            
            VStack(alignment: .leading, spacing: 28){
                SettingBtn(action: {pathManager.path.append(.SettingHome)})

                VStack(alignment:.leading ,spacing: 28){
                    Text("어떤 카피를 생성할까요?")
                        .fullScreenCover(isPresented: $isFirstLaunching) {
                            OnboardingView( isFirstLaunching: $isFirstLaunching, storeModel: storeModel)
                        }
                        .font(.system(size: 24,weight: .bold))
                    
                    VStack(spacing: 12){
                        NavigationBtn(header: "일상",description: "가벼운 카페 일상 글을 써요", action: {pathManager.path.append(.Daily)})
                        NavigationBtn(header: "메뉴",description: "카페의 메뉴에 대한 글을 써요", action: {pathManager.path.append(.Menu)})
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, paddingHorizontal)
            .padding(.top, paddingTop)
            .padding(.bottom, paddingBottom)
            .onAppear{
                //뷰 생성시 데이터를 초기화 합니다.
                viewModel.promptAnswer = "생성된 텍스트가 들어가요."
                resetData()
            }
            // TODO: 뷰 만들면 여기 스위치문에 넣어주세요
            .navigationDestination(for: StackViewType.self) { stackViewType in
                switch stackViewType {
                case .Menu:
                    MenuView()
                case .Daily:
                    DailyView()
                case .SettingHome:
                    SettingView()
                case .SettingStore:
                    SettingStoreView()
                case .SettingTone:
                    SettingToneView()
                case .Result:
                    ResultView()
                }
            }
        }
    }
}

// MARK: - 카테고리 버튼
private func NavigationBtn(header: String, description: String,action: @escaping () -> Void) -> some View {
    VStack {
        Button(action: {
            action()
        }) {
            RoundedRectangle(cornerRadius: radius2)
                .frame(maxWidth: .infinity)
                .frame(height: 106)
                .overlay(alignment: .leading) {
                    VStack(alignment: .leading,spacing: 8) {
                        Text(header)
                            .font(.title2())
                            .foregroundStyle(Color.gray6)
                        Text(description)
                            .font(.body2Bold())
                            .foregroundStyle(Color.gray4)
                    }
                    .padding(.horizontal,16)
                }
                .foregroundStyle(Color.sub)
        }
    }
}

// MARK: - 설정 버튼
private func SettingBtn(action: @escaping () -> Void) -> some View {
    HStack(alignment: .center) {
        Spacer()
        Button(action: {
            action()
        }, label: {
            Image(systemName: "gearshape")
                .resizable()
                .foregroundStyle(Color.gray5)
                .frame(width: 24,height: 24)
        })
    }
}

extension MainView : MainViewProtocol {
   
    func resetData() {
        menuModel.menuName = ""
        menuModel.menuPoint = ""
        menuModel.recordResult = ""
        
        dailyModel.recordResult = ""
    }
    
    func fetchStoreData() {
        
        let storeRequest = NSFetchRequest<StoreData>(entityName: "storeName")
        
        do {
            let storeDataArray = try storeDataManager.context.fetch(storeRequest)
            if let storeNameData = storeDataArray.first {
                self.storeModel.storeName = storeNameData.storeName
                self.storeModel.tone = storeNameData.tone ?? ""
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
        
    }
    
    func fetchDailyData() {
        
        let dailyRequest = NSFetchRequest<DailyData>(entityName: "dailyRecordId")
        
        do {
            let dailyDataArray = try DailyDataManager().context.fetch(dailyRequest)
            if let dailyUUID = dailyDataArray.first {
                self.dailyModel.recordID = dailyDataArray.recordID
                self.dailyModel.recordDate = dailyDataArray.recordDate
            }
        } catch {
            print("ERROR DAILY CORE DATA")
            print(error.localizedDescription)
        }
        
    }
    
    func fetchMenuData() {
        
        let MenuRequest = NSFetchRequest<MenuData>(entityName: "menuRecordId")
        
        do {
            let storeDataArray = try storeDataManager.context.fetch(storeRequest)
            if let storeNameData = storeDataArray.first {
                self.storeModel.storeName = storeNameData.storeName
                self.storeModel.tone = storeNameData.tone ?? ""
            }
        } catch {
            print("ERROR MENU CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func fetchAllData() {
        
        fetchStoreData()
        fetchDailyData()
        fetchMenuData()
        
    }
    
}
