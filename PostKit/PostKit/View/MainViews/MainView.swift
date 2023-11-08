//
//  MainView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//
import SwiftUI
import CoreData
import CloudKit
import AppTrackingTransparency

struct MainView: View {
    @AppStorage("_coin") var coin: Int = 0
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @EnvironmentObject var appstorageManager: AppstorageManager
    @EnvironmentObject var pathManager: PathManager
    @State private var isShowingToast = false
    //iCloud가 연동 확인 모델
    @StateObject private var iCloudData = CloudKitUserModel()
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var loadingModel = LoadingViewModel.shared
    private let pasteBoard = UIPasteboard.general
    
    //CoreData Manager
    private let coreDataManager = CoreDataManager.instance
    private let hapticManger = HapticManager.instance
    //AppStorage iCloud버전
    var keyStore = NSUbiquitousKeyValueStore()
    
    //CoreData 임시 Class
    @StateObject var storeModel = StoreModel( _storeName: "", _tone: [])
    @State private var captions: [CaptionModel] = []
    @State private var hashtags: [HashtagModel] = []
    
    //TabView의 선택된 View
    @State var selection = 0
    
    var body: some View {
        ZStack {
            //이미 Bool 값이 True면 비교 불필요
            if isFirstLaunching {
                OnboardingView( isFirstLaunching: $isFirstLaunching, storeModel: storeModel)
            } else {
                NavigationStack(path: $pathManager.path) {
                    TabView(selection: $selection) {
                        MainCaptionView()
                            .tabItem {
                                if selection == 0 {
                                    VStack{
                                        Image(.captionFocus)
                                    }
                                } else {
                                    Image(.caption)
                                }
                                Text("글 쓰기")
                            }
                            .tag(0)
                            .onTapGesture {hapticManger.notification(type: .success)}
                        
                        MainHistoryView()
                            .tabItem {
                                if selection == 1 {
                                    Image(.historyFocus)
                                } else {
                                    Image(.history)
                                }
                                Text("글 보기")
                            }
                            .tag(1)
                            .onTapGesture {hapticManger.notification(type: .success)}
                         
                    }

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
                        case .Loading:
                            LoadingView()
                        case .CaptionResult:
                            CaptionResultView(storeModel: storeModel)
                        case .HashtagResult:
                            HashtagResultView()
                        case .ErrorNetwork:
                            ErrorView(errorReasonState: .networkError, errorCasue: "네트워크 연결이\n원활하지 않아요", errorDescription: "네트워크 연결을 확인해주세요", errorImage: .errorNetwork)
                        case .ErrorResultFailed:
                            ErrorView(errorReasonState: .apiError, errorCasue: "생성을\n실패했어요", errorDescription: "예기치 못한 이유로 생성에 실패했어요\n다시 시도해주세요", errorImage: .errorFailed)
                        case .Hashtag:
                            HashtagView()
                        }
                    }
                }
                .navigationBarBackButtonHidden()
                .onAppear{
                    fetchStoreData()
                    viewModel.promptAnswer = "생성된 텍스트가 들어가요."
                    
                    fetchCaptionData()
                    fetchHashtagData()
                    loadingModel.inputArray.removeAll()
                    //Cloud 디버깅
                    print("iCloud Status")
                    print("IS SIGNED IN: \(iCloudData.isSignedIntoiCloud.description.uppercased())\nPermission Status: \(iCloudData.permissionStatus.description)\nUser Name: \(iCloudData.userName)")
                    print("\(iCloudData.error)")
                    
                    saveToCloud()
                }
            }
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
    
    func fetchStoreData() {
        let storeRequest = NSFetchRequest<StoreData>(entityName: "StoreData")
        
        do {
            let storeDataArray = try coreDataManager.context.fetch(storeRequest)
            if let storeCoreData = storeDataArray.last {
                self.storeModel.storeName = storeCoreData.storeName ?? ""
                // TODO: 코어데이터 함수 변경 필요
                self.storeModel.tone = storeCoreData.tones ?? []
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
                    _caption: captionCoreData.caption ?? "",
                    _like: captionCoreData.like 
                )
            }
            captions.sort { $0.date > $1.date }
           } catch {
               print("ERROR FETCHING CAPTION CORE DATA")
               print(error.localizedDescription)
           }
    }
    
    func fetchHashtagData() {
        let HashtagRequest = NSFetchRequest<HashtagData>(entityName: "HashtagData")
        
        do {
            let hashtagDataArray = try coreDataManager.context.fetch(HashtagRequest)
            hashtags = hashtagDataArray.map{ hashtagCoreData in
                return HashtagModel(
                    _id: hashtagCoreData.resultId ?? UUID(),
                    _date: hashtagCoreData.date ?? Date(),
                    _locationTag: hashtagCoreData.locationTag ?? [""],
                    _keyword: hashtagCoreData.keyword ?? [""],
                    _hashtag: hashtagCoreData.hashtag ?? "", 
                    _isLike: hashtagCoreData.like
                )
            }
            hashtags.sort { $0.date > $1.date }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func saveCaptionData(_uuid: UUID, _result: String, _like: Bool) {
        let fetchRequest = NSFetchRequest<CaptionResult>(entityName: "CaptionResult")
        
        // captionModel의 UUID가 같을 경우
        let predicate = NSPredicate(format: "resultId == %@", _uuid as CVarArg)
        fetchRequest.predicate = predicate
        
        if let existingCaptionResult = try? coreDataManager.context.fetch(fetchRequest).first {
            // UUID에 해당하는 데이터를 찾았을 경우 업데이트
            existingCaptionResult.caption = _result
            existingCaptionResult.like = _like
            
            coreDataManager.save() // 변경사항 저장
            
            print("Caption 수정 완료!\n resultId : \(existingCaptionResult.resultId)\n Date : \(existingCaptionResult.date)\n Category : \(existingCaptionResult.category)\n Caption : \(existingCaptionResult.caption)\n")
        } else {
            // UUID에 해당하는 데이터가 없을 경우 새로운 데이터 생성
            let newCaption = CaptionResult(context: coreDataManager.context)
            newCaption.resultId = _uuid
            newCaption.caption = _result
            newCaption.like = _like
            
            coreDataManager.save() // 변경사항 저장
            
            print("Caption 새로 저장 완료!\n resultId : \(_uuid)\n Date : \(newCaption.date)\n Category : \(newCaption.category)\n Caption : \(newCaption.caption)\n")
        }
    }
    
    func saveHashtagData(_uuid: UUID, _result: String, _like: Bool) {
        let fetchRequest = NSFetchRequest<HashtagData>(entityName: "HashtagData")
        
        // captionModel의 UUID가 같을 경우
        let predicate = NSPredicate(format: "resultId == %@", _uuid as CVarArg)
        fetchRequest.predicate = predicate
        
        if let existingCaptionResult = try? coreDataManager.context.fetch(fetchRequest).first {
            // UUID에 해당하는 데이터를 찾았을 경우 업데이트
            existingCaptionResult.hashtag = _result
            existingCaptionResult.like = _like
            
            coreDataManager.save() // 변경사항 저장
            
            print("Hashtag 수정 완료!\n resultId : \(existingCaptionResult.resultId)\n Date : \(existingCaptionResult.date)\nHashtag : \(existingCaptionResult.hashtag)\n")
        } else {
            // UUID에 해당하는 데이터가 없을 경우 새로운 데이터 생성
            let newCaption = HashtagData(context: coreDataManager.context)
            newCaption.resultId = _uuid
            newCaption.hashtag = _result
            newCaption.like = _like
            
            coreDataManager.save() // 변경사항 저장
            
            print("Hashtag 수정 완료!\n resultId : \(newCaption.resultId)\n Date : \(newCaption.date)\nHashtag : \(newCaption.hashtag)\n")
        }
    }
    
    func deleteCaptionData(_uuid: UUID) {
        let fetchRequest = NSFetchRequest<CaptionResult>(entityName: "CaptionResult")
        
        // NSPredicate를 사용하여 UUID가 같을 경우 삭제
        let predicate = NSPredicate(format: "resultId == %@", _uuid as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let captionArray = try coreDataManager.context.fetch(fetchRequest)
            
            //이곳에서 삭제 합니다.
            for captionEntity in captionArray {
                coreDataManager.context.delete(captionEntity)
            }
            
            //코어데이터에 삭제 후 결과를 저장
            try coreDataManager.context.save()
        } catch {
            print("Error deleting data: \(error)")
        }
    }
    
    func deleteHashtagData(_uuid: UUID) {
        let fetchRequest = NSFetchRequest<HashtagData>(entityName: "HashtagData")
        
        // NSPredicate를 사용하여 UUID가 같을 경우 삭제
        let predicate = NSPredicate(format: "resultId == %@", _uuid as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let hashtagArray = try coreDataManager.context.fetch(fetchRequest)
            
            for hashtagEntity in hashtagArray {
                coreDataManager.context.delete(hashtagEntity)
            }
            
            try coreDataManager.context.save()
        } catch {
            print("Error deleting data: \(error)")
        }
    }
    
    func convertDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
      
        var convertDate = formatter.string(from: date)
        
        return convertDate
    }
}

extension MainView : iCloudProtocol {
    func fetchAllFromCloud() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Store",predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.database =  CKContainer(identifier: "iCloud.com.PostKit")
            .publicCloudDatabase
        
        operation.recordMatchedBlock = { recordID, result in
            print("💿", recordID)
            switch result {
            case .success(let record):
                print("📀", record)
            case .failure(let error):
                print(error)
            }
        }

        operation.start()
    }
    
    func saveToCloud() {
        let record = CKRecord(recordType: "Store")
        record.setValuesForKeys(["StoreName": "TestStoreName", "StoreTone": "저장톤"])
        
        let container = CKContainer(identifier: "iCloud.com.PostKit")
        container.publicCloudDatabase.save(record) { record, error in
            print("저장완료! \(record)")
        }
    }
    
    func updateCloud() {
        //아직
    }
    
    func deleteCloud() {
        //개발중
    }
}
