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
    let coreDataManager = CoreDataManager.instance
    
    //CoreData 임시 Class
    @StateObject var storeModel = StoreModel( _storeName: "", _tone: ["기본"])
    
    
    var body: some View {
        ZStack {
            if isFirstLaunching == true {
                OnboardingView( isFirstLaunching: $isFirstLaunching, storeModel: storeModel)
            }
            else {
                NavigationStack(path: $pathManager.path) {
                    TabView {
                        mainCaptionView
                            .tabItem {
                                Image(systemName: "plus.app.fill")
                                Text("생성")
                            }
                        
                        mainHistoryView
                            .tabItem {
                                Image(systemName: "clock.fill")
                                Text("히스토리")
                            }
                    }
                    // TODO: 뷰 만들면 여기 스위치문에 넣어주세요
                    .navigationDestination(for: StackViewType.self) { stackViewType in
                        switch stackViewType {
                        case .Menu:
                            MenuView(storeModel: storeModel)
                        case .Daily:
                            DailyView(storeModel: storeModel)
                        case .SettingHome:
                            SettingView(storeModel: storeModel)
                        case .SettingStore:
                            SettingStoreView(storeName: $storeModel.storeName)
                        case .SettingTone:
                            SettingToneView(storeTone: $storeModel.tone)
                        case .CaptionResult:
                            CaptionResultView(storeModel: storeModel)
                        }
                    }
                }
                .navigationBarBackButtonHidden()
                .onAppear{
                    fetchAllData()
                    viewModel.promptAnswer = "생성된 텍스트가 들어가요."
                    resetData()
                }
            }
            
        }
        
    }
}

// MARK: - 카테고리 버튼
private func NavigationBtn(header: String, description: String,action: @escaping () -> Void) -> some View {
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

extension MainView {
    private var mainCaptionView: some View {
        ContentArea {
            
            VStack(spacing: 28) {
                SettingBtn(action: {pathManager.path.append(.SettingHome)})
                
                VStack(alignment: .leading, spacing: 28) {
                    
                    Text("어떤 카피를 생성할까요?")
                        .font(.title1())
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("캡션")
                            .font(.body2Bold())
                            .foregroundColor(Color.gray4)
                        
                        NavigationBtn(header: "일상",description: "가벼운 카페 일상 글을 써요", action: {pathManager.path.append(.Daily)})
                        
                        NavigationBtn(header: "메뉴",description: "카페의 메뉴에 대한 글을 써요", action: {pathManager.path.append(.Menu)})
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("해시태그")
                            .font(.body2Bold())
                            .foregroundColor(Color.gray4)
                        
                        NavigationBtn(header: "해시태그",description: "가벼운 카페 일상 글을 써요", action: {
                            //TODO: 해시태그 생성 뷰 만들면 여기에 path추가해 주세요!
                        })
                    }
                }
                
                Spacer()
            }
        }
       
    }
    
    private var mainHistoryView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("히스토리 예정입니다.")
        }
    }
    
}

extension MainView : MainViewProtocol {
    
    func resetData() {
        
    }
    
    func fetchStoreData() {
        
        let storeRequest = NSFetchRequest<StoreData>(entityName: "StoreData")
        
        do {
            let storeDataArray = try coreDataManager.context.fetch(storeRequest)
            if let storeCoreData = storeDataArray.last {
                self.storeModel.storeName = storeCoreData.storeName ?? ""
                // TODO: 코어데이터 함수 변경 필요
                //                self.storeModel.tone = storeCoreData.tone ?? ["기본"]
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
        
    }
    
    func fetchAllData() {
        fetchStoreData()
        
    }
    
}
