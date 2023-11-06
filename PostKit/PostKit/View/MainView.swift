//
//  MainView.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//
import SwiftUI
import CoreData
import CloudKit

struct MainView: View {
    @AppStorage("_coin") var coin: Int = 0
    @AppStorage("_cafeName") var cafeName: String = ""
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    @EnvironmentObject var appstorageManager: AppstorageManager
    @EnvironmentObject var pathManager: PathManager
    @State private var isShowingToast = false
    @State var historySelected = "피드 글"
    @State private var showModal = false
    @State private var isCaptionChange = false
    //iCloud가 연동 확인 모델
    @StateObject private var iCloudData = CloudKitUserModel()
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var coinManager = CoinManager.shared
    @Namespace var nameSpace
    private let pasteBoard = UIPasteboard.general
    
    //CoreData Manager
    private let coreDataManager = CoreDataManager.instance
    private let hapticManger = HapticManager.instance
    //AppStorage iCloud버전
    var keyStore = NSUbiquitousKeyValueStore()
    
    //CoreData 임시 Class
    @StateObject var storeModel = StoreModel( _storeName: "", _tone: ["기본"])
    @State private var captions: [CaptionModel] = []
    @State private var hashtags: [HashtagModel] = []
    
    var body: some View {
        ZStack {
            //이미 Bool 값이 True면 비교 불필요
            if isFirstLaunching {
                OnboardingView( isFirstLaunching: $isFirstLaunching, storeModel: storeModel)
            } else {
                NavigationStack(path: $pathManager.path) {
                    TabView {
                        mainCaptionView
                            .tabItem {
                                Image(systemName: "plus.app.fill")
                                Text("생성")
                            }
                            .onTapGesture {hapticManger.notification(type: .success)}
                        
                        mainHistoryView
                            .tabItem {
                                Image(systemName: "clock.fill")
                                Text("히스토리")
                            }
                            .onTapGesture {hapticManger.notification(type: .success)}
                            .onAppear{
                                fetchCaptionData()
                                fetchHashtagData()
                            }
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
                    
                    fetchCaptionData()
                    fetchHashtagData()
                    
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
            
            VStack(alignment:.leading ,spacing: 28) {
                SettingBtn(action: {pathManager.path.append(.SettingHome)})
                
                VStack(alignment: .leading, spacing: 28) {
                    
                    Text("\(coinManager.coin)")
                    
                    Text("어떤 카피를 생성할까요?")
                        .font(.title1())
                    
                    VStack(alignment: .leading, spacing: 20) {
                        captionArea()
                        hashtagArea()
                    }
                }
                Spacer()
            }
        }
    }
    
    private func captionBtn(captionName: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: radius2)
                .foregroundColor(Color.white)
                .frame(height: 60)
                .overlay(alignment: .center) {
                    Text(captionName)
                        .font(.body1Bold())
                        .foregroundColor(Color.gray5)
                }
        }
    }
    
    private func hashtagArea() -> some View {
        Button {
            pathManager.path.append(.Hashtag)
        } label: {
            RoundedRectangle(cornerRadius: radius1)
                .frame(height: 104)
                .foregroundColor(Color.sub)
                .overlay(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("해시태그")
                            .font(.title2())
                            .foregroundColor(Color.gray6)
                        
                        Text("우리 카페에는 어떤 해시태그가 어울릴까?")
                            .font(.body2Bold())
                            .foregroundColor(Color.gray4)
                    }
                    .padding(.vertical,28)
                    .padding(.horizontal,16)
                }
        }
    }
    
    private func captionArea() -> some View {
        RoundedRectangle(cornerRadius: radius1)
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.sub)
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("캡션")
                            .font(.title2())
                            .foregroundColor(Color.gray6)
                        Text("카페의 메뉴에 대한 글을 써요")
                            .font(.body2Bold())
                            .foregroundColor(Color.gray4)
                    }
                    
                    HStack(spacing: 8) {
                        captionBtn(captionName: "일상", action: {pathManager.path.append(.Daily)})
                        captionBtn(captionName: "메뉴", action: {pathManager.path.append(.Menu)})
                    }
                    
                }
                .padding(.vertical,28)
                .padding(.horizontal,16)
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
                            .highPriorityGesture(DragGesture())
                            .tag("피드 글")
                           
                        hashtagHistory
                            .highPriorityGesture(DragGesture())
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
                withAnimation(.spring(response: 0.5,dampingFraction: 0.8)) {
                    historySelected = "피드 글"
                }
            }, label: {
                Text("피드 글")
                    .font(.title2())
                    .foregroundColor(Color.black)
                    .overlay(alignment: .bottom) {
                        if historySelected == "피드 글" {
                            Rectangle()
                                .foregroundColor(Color.black)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "activeStroke", in: nameSpace)
                        }
                    }
            })
            
            Button(action: {
                withAnimation(.spring(response: 0.5,dampingFraction: 0.8)) {
                    historySelected = "해시태그"
                }
            }, label: {
                Text("해시태그")
                    .font(.title2())
                    .foregroundColor(Color.black)
                    .overlay(alignment: .bottom) {
                        if historySelected == "해시태그" {
                            Rectangle()
                                .foregroundColor(Color.black)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "activeStroke", in: nameSpace)
                        }
                    }
            })
        }
    }
    
    private var feedHistory: some View {
        
        VStack {
            ScrollView{
                ForEach($captions) { $item in
                    //TODO: 좋아요가 추가되었습니다. 뷰의 변경 필요
                    feedHisoryDetail(uid: item.id, tag: item.category, date: convertDate(date: item.date), content: $item.caption, like: item.like)
                        .onChange(of: item.like){ _ in
                            saveCaptionData(_uuid: item.id, _result: item.caption, _like: item.like)
                        }
                }
            }
            .refreshable{fetchCaptionData()}
        }
        .toast(isShowing: $isShowingToast)
    }
    
    private var hashtagHistory: some View {
        VStack {
            ScrollView{
                ForEach($hashtags) { $item in
                    hashtagHistoryDetail(uid: item.id, date: item.date, hashtagContent: $item.hashtag, hashtageLike: item.isLike)
                        .onChange(of: item.isLike){ _ in
                            saveHashtagData(_uuid: item.id, _result: item.hashtag, _like: item.isLike)
                        }
                }
            }
            .refreshable {fetchHashtagData()}
        }
        .toast(isShowing: $isShowingToast)
    }
    
    private func feedHisoryDetail(uid: UUID, tag: String, date: String, content: Binding<String>, like: Bool) -> some View {
        RoundedRectangle(cornerRadius: radius1)
            .frame(height: 160)
            .foregroundColor(Color.gray1)
        //TODO: 수정 버튼이 적용이 안돼서 일단 임시 주석처리
        //            .onTapGesture {
        //                copyToClipboard()
        //            }
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
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
                        Text(date)
                            .font(.body2Bold())
                            .foregroundColor(Color.gray4)
                        Spacer()
                        Menu {
                            Button(action: {
                                self.showModal = true
                            }) {
                                HStack {
                                    Text("수정하기")
                                    Spacer()
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                            Button(role: .destructive, action: {
                                //TODO: 삭제하기 action 추가 해야함
                                deleteCaptionData(_uuid: uid)
                                fetchCaptionData()
                                //MARK: item.id 값 필요
                            }) {
                                HStack {
                                    Text("삭제하기")
                                    Spacer()
                                    Image(systemName: "trash")
                                }
                            }
                        } label: {
                            Label("", systemImage: "ellipsis")
                        }
                    }
                    
                    Text(content.wrappedValue)
                        .font(.body2Bold())
                        .foregroundColor(Color.gray5)
                }
                .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
            }
            .sheet(isPresented: self.$showModal) {
                ResultUpdateModalView(
                    showModal: $showModal, isChange: $isCaptionChange,
                    stringContent: content,
                    resultUpdateType: .captionResult
                ) { updatedText in
                    saveCaptionData(_uuid: uid, _result: content.wrappedValue, _like: like)
                }
                .interactiveDismissDisabled()
            }
    }
    
    private func hashtagHistoryDetail(uid: UUID,date : Date, hashtagContent: Binding<String>, hashtageLike : Bool) -> some View {
        RoundedRectangle(cornerRadius: radius1)
            .frame(height: 160)
            .foregroundColor(Color.gray1)
        //TODO: 수정 버튼이 적용이 안돼서 일단 임시 주석처리
        //            .onTapGesture {
        //                copyToClipboard()
        //            }
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        
                        Text(date, style: .date)
                            .font(.body2Bold())
                            .foregroundColor(Color.gray4)
                        
                        Spacer()
                        
                        Menu {
                            Button(action: {
                                self.showModal = true
                            }) {
                                HStack {
                                    Text("수정하기")
                                    Spacer()
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                            Button(role: .destructive, action: {
                                //TODO: 삭제하기 action 추가 해야함
                                deleteHashtagData(_uuid: uid)
                                fetchHashtagData()
                                //MARK: item.id 값 필요
                            }) {
                                HStack {
                                    Text("삭제하기")
                                    Spacer()
                                    Image(systemName: "trash")
                                }
                            }
                        } label: {
                            Label("", systemImage: "ellipsis")
                        }
                    }
                    
                    Text(hashtagContent.wrappedValue)
                        .font(.body2Bold())
                        .foregroundColor(Color.gray5)
                }
                .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
            }
            .sheet(isPresented: self.$showModal) {
                ResultUpdateModalView(
                    showModal: $showModal, isChange: $isCaptionChange,
                    stringContent: hashtagContent,
                    resultUpdateType: .hashtagResult
                ) { updatedText in
                    saveHashtagData(_uuid: uid, _result: hashtagContent.wrappedValue, _like: hashtageLike)
                }
                .interactiveDismissDisabled()
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
