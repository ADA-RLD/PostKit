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
    
    //CoreData Manager
    let storeDataManager = StoreDataManager.instance
    let dailyDataManager = DailyDataManager.instance
    let menuDataManager = MenuDataManager.instance
    
    //CoreData 임시 Class
    @StateObject var storeModel = StoreModel( _storeName: "", _tone: "기본")
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
                    SettingView(storeModel: storeModel)
                case .SettingStore:
                    SettingStoreView(storeName: $storeModel.storeName)
                case .SettingTone:
                    SettingToneView(storeTone: $storeModel.tone)
                case .CaptionResult:
                    CaptionResultView()
                }
            }
        }
        .onAppear{
            fetchAllData()
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
        
        let storeRequest = NSFetchRequest<StoreData>(entityName: "StoreData")
        
        do {
            let storeDataArray = try storeDataManager.context.fetch(storeRequest)
            if let storeCoreData = storeDataArray.last {
                self.storeModel.storeName = storeCoreData.storeName ?? ""
                self.storeModel.tone = storeCoreData.tone ?? "기본"
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
        
    }
    
    func fetchDailyData() {
        
        let dailyRequest = NSFetchRequest<DailyData>(entityName: "DailyData")
        
        do {
            let dailyDataArray = try dailyDataManager.context.fetch(dailyRequest)
            if let dailyCoreData = dailyDataArray.first {
                self.dailyModel.recordDate = dailyCoreData.recordDate
                self.dailyModel.weather = dailyCoreData.weather
                self.dailyModel.dessert = dailyCoreData.dessert
                self.dailyModel.drink = dailyCoreData.drink
            }
        } catch {
            print("ERROR DAILY CORE DATA")
            print(error.localizedDescription)
        }
        
    }
    
    func fetchMenuData() {
        
        let menuRequest = NSFetchRequest<MenuData>(entityName: "MenuData")
        
        do {
            let menuDataArray = try menuDataManager.context.fetch(menuRequest)
            if let menuCoreData = menuDataArray.first {
                self.menuModel.menuName = menuCoreData.menuName ?? ""
                self.menuModel.menuPoint = menuCoreData.menuPoint ?? ""
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
