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
    @State private var isShowingToast = false
    @State var historySelected = "피드 글"
    @ObservedObject var viewModel = ChatGptViewModel.shared
    private let pasteBoard = UIPasteboard.general
    
    //CoreData Manager
    private let coreDataManager = CoreDataManager.instance
    private let hapticManger = HapticManager.instance
    
    //CoreData 임시 Class
    @StateObject var storeModel = StoreModel( _storeName: "", _tone: ["기본"])
    @State private var captions: [CaptionModel] = []
    
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
                            .onTapGesture {
                                hapticManger.notification(type: .success)
                            }
                        
                        mainHistoryView
                            .tabItem {
                                Image(systemName: "clock.fill")
                                Text("히스토리")
                            }
                            .onTapGesture {
                                hapticManger.notification(type: .success)
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
                        case .HashtagResult:
                            HashtagResultView()
                        case .ErrorNetwork:
                            ErrorView(errorCasue: "네트워크 문제", errorDescription: "네트워크 연결을 확인해주세요")
                        case .ErrorResultFailed:
                            ErrorView(errorCasue: "결과 생성 실패", errorDescription: "결과 생성에 실패했어요 ㅠ-ㅠ")
                        case .Hashtag:
                            HashtagView()
                        }
                    }
                }
                .navigationBarBackButtonHidden()
                .onAppear{
                    fetchStoreData()
                    viewModel.promptAnswer = "생성된 텍스트가 들어가요."
                    resetData()
                    
                    fetchCaptionData()
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

//MARK: extension: MainView Views
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
                        
                        NavigationBtn(header: "해시태그",description: "가벼운 카페 일상 글을 써요", action: {pathManager.path.append(.Hashtag)
                            //TODO: 해시태그 생성 뷰 만들면 여기에 path추가해 주세요!
                        })
                    }
                }
                
                Spacer()
            }
        }
       
    }
    
    private var mainHistoryView: some View {
        ContentArea {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("히스토리")
                        .font(.title1())
                        .foregroundColor(Color.gray6)
                    
                    Text("히스토리를 탭하면 내용이 복사됩니다.")
                        .font(.body2Bold())
                        .foregroundColor(Color.gray4)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    historyIndicator
                    
                    TabView(selection: $historySelected) {
                        
                        feedHistory
                            .tag("피드 글")
                        
                        hashtagHistory
                            .tag("해시태그")
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                }
            }
        }
    }
    
    private var historyIndicator: some View {
        HStack(spacing: 16) {
            
            Button(action: {
                historySelected = "피드 글"
            }, label: {
                Text("피드 글")
            })
            
            Button(action: {
                historySelected = "해시태그"
            }, label: {
                Text("해시태그")
            })
        }
    }
    
    private var feedHistory: some View {
        
        VStack {
            ScrollView{
                ForEach(captions) { item in
                    feedHisoryDetail(tag: item.category, date: item.date, content: item.caption)
                }
            }
        }
        .toast(isShowing: $isShowingToast)
    }
    
    // TODO: 해시태그 히스토리는 여기에 작업해주세요
    private var hashtagHistory: some View {
        VStack {
            ScrollView{
                hashtagHistoryDetail(date: Date(), hashtagContent: "#서울카페 #서울숲카페 #서울숲브런치맛집 #성수동휘낭시에 #성수동여행 #서울숲카페탐방 #성수동디저트 #성수동감성카페 #서울신상카페 #서울숲카페거리 #성수동분위기좋은카페 #성수동데이트 #성수동핫플 #서울숲핫플레이스")
            }
        }
        .toast(isShowing: $isShowingToast)
    }
    
    private func feedHisoryDetail(tag: String, date: Date, content: String) -> some View {
        RoundedRectangle(cornerRadius: radius1)
            .frame(height: 160)
            .onTapGesture {
                copyToClipboard()
            }
            .foregroundColor(Color.gray1)
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack(spacing: 0) {
                        
                        Text(tag)
                            .font(.body2Bold())
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 9.5)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .background(Color.main)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(.clear)
                            }
            
                        Spacer()
                        
                        Text(date, style: .date)
                            .font(.body2Bold())
                            .foregroundColor(Color.gray4)
                    }
                    
                    Text(content)
                        .font(.body2Bold())
                        .foregroundColor(Color.gray5)
                    
                }
                .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
            }
    }
    
    private func hashtagHistoryDetail(date : Date, hashtagContent : String) -> some View {
        RoundedRectangle(cornerRadius: radius1)
            .frame(height: 160)
            .foregroundColor(Color.gray1)
            .onTapGesture {
                copyToClipboard()
            }
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(date, style: .date)
                        .font(.body2Bold())
                        .foregroundColor(Color.gray4)
                    
                    Text(hashtagContent)
                        .font(.body2Bold())
                        .foregroundColor(Color.gray5)
                }
                .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
            }
      }
}


//MARK: extension MainView Functions
extension MainView {
    // MARK: - 카피 복사
    private func copyToClipboard() {
        hapticManger.notification(type: .success)
        pasteBoard.string = viewModel.promptAnswer
        isShowingToast = true
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
                self.storeModel.tone = storeCoreData.tones ?? ["기본"]
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func fetchCaptionData() {
        let CaptionRequest = NSFetchRequest<CaptionResult>(entityName: "CaptionResult")
        
        do {
               let captionArray = try coreDataManager.context.fetch(CaptionRequest)
            captions = captionArray.map { captionCoreData in
                return CaptionModel(
                    _id: captionCoreData.resultId ?? UUID(),
                    _date: captionCoreData.date ?? Date(),
                    _category: captionCoreData.category ?? "",
                    _caption: captionCoreData.caption ?? ""
                )
            }
           } catch {
               print("ERROR FETCHING CAPTION CORE DATA")
               print(error.localizedDescription)
           }
    }
}
