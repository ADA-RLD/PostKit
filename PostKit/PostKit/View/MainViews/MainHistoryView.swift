//
//  MainHistoryView.swift
//  PostKit
//
//  Created by 김다빈 on 11/6/23.
//

import SwiftUI
import CoreData

final class LikeFilter: ObservableObject {
    static let shared = LikeFilter()
    @Published var isLiked : Bool
    
    init(isLiked: Bool = false) {
        self.isLiked = isLiked
    }
}

struct MainHistoryView: View {
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var filterLike = LikeFilter.shared
    @State var historySelected = "피드 글"
    @State private var captions: [CaptionModel] = []
    @State private var hashtags: [HashtagModel] = []
    @State private var isShowingToast = false
    @State private var isCaptionChange = false
    @State private var isCaptionLiked = false
    @State private var targetUid = UUID()
    @State private var showModal = false
    @State private var showAlert = false
    @State private var alertType: AlertType = .historyCaption
    @Binding var selection: Int
    @Namespace var nameSpace
    
    private let hapticManger = HapticManager.instance
    private let pasteBoard = UIPasteboard.general
    private let copyManger = CopyManger.instance
    
    //CoreData Manager
    private let coreDataManager = CoreDataManager.instance
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 28) {
                HStack {
                    //historyIndicator
                    Text("글 보기")
                        .title1(textColor: .gray6)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    Image(.heart)
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(filterLike.isLiked ? .main : .gray3)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.3)) {
                                filterLike.isLiked.toggle()
                                if filterLike.isLiked {
                                    captions = captions.filter { $0.like == true }
                                    //hashtags = hashtags.filter { $0.isLike == true }
                                } else {
                                    fetchCaptionData()
                                    fetchHashtagData()
                                }
                            }
                        }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    TabView(selection: $historySelected) {
                        feedHistory
                            .highPriorityGesture(DragGesture())
                            .tag("피드 글")
                        
//                        hashtagHistory
//                            .highPriorityGesture(DragGesture())
//                            .tag("해시태그")
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .zIndex(0)
            
            if showAlert {
                CustomAlertMessageDouble(alertTopTitle: "히스토리를 삭제할까요?", alertContent: "삭제된 글은 복구할 수 없어요", topBtnLabel: "삭제",
                                         bottomBtnLabel: "취소", topAction: {
                    if alertType == .historyCaption {
                        deleteCaptionData(_uuid: targetUid)
                        fetchCaptionData()
                    }
                    else if alertType == .historyHashtag {
                        deleteHashtagData(_uuid: targetUid)
                        fetchHashtagData()
                    }
                    showAlert = false
                }, bottomAction: { showAlert = false }, showAlert: $showAlert)
            }
        }
        .toast(toastText: "클립보드에 복사했어요", toastImgRes: Image(.copy), isShowing: $isShowingToast)
    }
}

extension MainHistoryView {
    private var historyIndicator: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    historySelected = "피드 글"
                    alertType = .historyCaption
                }
            }, label: {
                Text("피드 글")
                    .title2(textColor: historySelected == "피드 글" ? .gray6 : .gray3)
                    .padding(.bottom, 8)
                    .overlay(alignment: .bottom) {
                        if historySelected == "피드 글" {
                            Rectangle()
                                .foregroundColor(.gray6)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "activeStroke", in: nameSpace)
                        }
                    }
            })
            
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    historySelected = "해시태그"
                    alertType = .historyHashtag
                }
            }, label: {
                Text("해시태그")
                    .title2(textColor: historySelected == "해시태그" ? .gray6 : .gray3)
                    .padding(.bottom, 8)
                    .overlay(alignment: .bottom) {
                        if historySelected == "해시태그" {
                            Rectangle()
                                .foregroundColor(.gray6)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "activeStroke", in: nameSpace)
                        }
                    }
            })
        }
        .padding(.top, 8)
    }
    
    private var feedHistory: some View {
        VStack(spacing: 0){
            ScrollView{
                if captions.isEmpty {
                    HistoryEmptyView(topTitleLable: filterLike.isLiked ? "아직 좋아요한 글이 없어요" : "아직 작성한 글이 없어요", bottomTitleLable: "글을 생성해볼까요?", historyImage: .historyEmpty, selection: $selection)
                }
                else {
                    VStack(spacing: 20){
                        ForEach($captions) { $item in
                            feedHisoryDetail(uid: item.id, tag: item.category, date: convertDate(date: item.date), content: $item.caption, like: $item.like)
                                .onChange(of: item.like){ _ in
                                    saveCaptionData(_uuid: item.id, _result: item.caption, _like: item.like)
                                    if filterLike.isLiked {
                                        captions = captions.filter { $0.like == true }
                                        //hashtags = hashtags.filter { $0.isLike == true }
                                    } else {
                                        fetchCaptionData()
                                        fetchHashtagData()
                                    }
                                }
                        }
                    }
                }
            }
            .refreshable {
                if filterLike.isLiked {
                    captions = captions.filter { $0.like == true }
                } else {
                    fetchHashtagData()
                }
            }
        }
        .onAppear {
            if filterLike.isLiked {
                fetchCaptionData()
                fetchHashtagData()
                captions = captions.filter { $0.like == true }
                //hashtags = hashtags.filter { $0.isLike == true }
            } else {
                fetchCaptionData()
                fetchHashtagData()
            }
        }
    }
    
    private var hashtagHistory: some View {
        VStack(spacing: 0) {
            ScrollView{
                if hashtags.isEmpty {
                    HistoryEmptyView(topTitleLable: filterLike.isLiked ? "아직 좋아요한 글이 없어요" : "아직 작성한 글이 없어요", bottomTitleLable: "글을 생성해볼까요?", historyImage: .historyEmpty, selection: $selection)
                }
                else {
                    VStack(spacing: 20){
                        ForEach($hashtags) { $item in
                            hashtagHistoryDetail(uid: item.id, date: convertDate(date: item.date), hashtagContent: $item.hashtag, hashtagLike: $item.isLike)
                                .onChange(of: item.isLike){ _ in
                                    saveHashtagData(_uuid: item.id, _result: item.hashtag, _like: item.isLike)
                                    if filterLike.isLiked {
                                        captions = captions.filter { $0.like == true }
                                        //hashtags = hashtags.filter { $0.isLike == true }
                                    } else {
                                        fetchCaptionData()
                                        fetchHashtagData()
                                    }
                                }
                        }
                    }
                }
            }
            .refreshable {
                if filterLike.isLiked {
                    //hashtags = hashtags.filter { $0.isLike == true }
                } else {
                    fetchHashtagData()
                }
            }
        }
        .onAppear {
            if filterLike.isLiked {
                fetchCaptionData()
                fetchHashtagData()
                captions = captions.filter { $0.like == true }
                //hashtags = hashtags.filter { $0.isLike == true }
            } else {
                fetchCaptionData()
                fetchHashtagData()
            }
        }
    }
    
    private func feedHisoryDetail(uid: UUID, tag: String, date: String, content: Binding<String>, like: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(date)
                        .body2Bold(textColor: .gray4)
                    if tag == "일상" || tag == "메뉴" {
                        Text("카페")
                            .body2Bold(textColor: .gray4)
                    }
                    else {
                        Text("패션")
                            .body2Bold(textColor: .gray4)
                    }
                    
                   
                }
                
                Text(content.wrappedValue)
                    .body2Bold(textColor: .gray5)
            }
            
            Divider()
                .foregroundColor(.gray2)
            
            HStack(spacing: 28) {
                HStack{
                    Image(.heart)
                        .foregroundColor(like.wrappedValue ? .main : .gray3)
                        .onTapGesture{
                            like.wrappedValue.toggle()
                        }
                    
                    Spacer()
                    
                    Image(.pen)
                        .foregroundColor(.gray3)
                        .onTapGesture {
                            self.showModal = true
                        }
                    
                    Spacer()
                    
                    Image(.trash)
                        .onTapGesture {
                            showAlert.toggle()
                            targetUid = uid
                        }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                
                HStack(spacing: 4) {
                    Image(.copy)
                    Text("복사")
                        .body2Bold(textColor: .white)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: radius1)
                        .fill(Color.gray5)
                        .onTapGesture {
                            copyManger.copyToClipboard(copyString: content.wrappedValue)
                            isShowingToast = true
                        }
                )
            }
            .padding(.horizontal, 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .clipShape(RoundedRectangle(cornerRadius: radius1))
        .foregroundColor(.clear)
        .overlay {
            RoundedRectangle(cornerRadius: radius1)
                .stroke(Color.gray2, lineWidth: 1)
        }
        .sheet(isPresented: self.$showModal) {
            ResultUpdateModalView(
                showModal: $showModal, isChange: $isCaptionChange,
                stringContent: content,
                resultUpdateType: .captionResult
            ) .onChange(of: isCaptionChange) { _ in
                saveCaptionData(_uuid: uid, _result: content.wrappedValue, _like: like.wrappedValue)
            }
            .interactiveDismissDisabled()
        }
    }
    
    private func hashtagHistoryDetail(uid: UUID, date: String, hashtagContent: Binding<String>, hashtagLike : Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(date)
                        .body2Bold(textColor: .gray4)
                }
                
                Text(hashtagContent.wrappedValue)
                    .body2Bold(textColor: .gray5)
            }
            
            Divider()
                .foregroundColor(.gray2)
            
            HStack(spacing: 28) {
                HStack{
                    Image(.heart)
                        .foregroundColor(hashtagLike.wrappedValue ? .main : .gray3)
                        .onTapGesture{
                            hashtagLike.wrappedValue.toggle()
                        }
                    
                    Spacer()
                    
                    Image(.pen)
                        .foregroundColor(.gray3)
                        .onTapGesture {
                            self.showModal = true
                        }
                    
                    Spacer()
                    
                    Image(.trash)
                        .onTapGesture {
                            showAlert.toggle()
                            targetUid = uid
                        }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                
                HStack(spacing: 4) {
                    Image(.copy)
                    Text("복사")
                        .body2Bold(textColor: .white)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: radius1)
                        .fill(Color.gray5)
                        .onTapGesture {
                            copyManger.copyToClipboard(copyString: hashtagContent.wrappedValue)
                            isShowingToast = true
                        }
                )
            }
            .padding(.horizontal, 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .clipShape(RoundedRectangle(cornerRadius: radius1))
        .foregroundColor(.clear)
        .overlay {
            RoundedRectangle(cornerRadius: radius1)
                .stroke(Color.gray2, lineWidth: 1)
        }
        .sheet(isPresented: self.$showModal) {
            ResultUpdateModalView(
                showModal: $showModal, isChange: $isCaptionChange,
                stringContent: hashtagContent,
                resultUpdateType: .hashtagResult
            )
            .onChange(of: isCaptionChange){ _ in
                saveHashtagData(_uuid: uid, _result: hashtagContent.wrappedValue, _like: hashtagLike.wrappedValue)
            }
            .interactiveDismissDisabled()
        }
    }
    
    private func copyToClipboard() {
        hapticManger.notification(type: .success)
        pasteBoard.string = viewModel.promptAnswer
        isShowingToast = true
    }
}

extension MainHistoryView : MainViewProtocol {
    func fetchStoreData() {
        // 해쉬태그에서는 쓰지 않습니다.
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
            
            print("Caption 수정 완료!\n resultId : \(existingCaptionResult.resultId)\n Date : \(existingCaptionResult.date)\n Category : \(existingCaptionResult.category)\n Caption : \(existingCaptionResult.caption)\nisLike : \(_like)")
        } else {
            // UUID에 해당하는 데이터가 없을 경우 새로운 데이터 생성
            let newCaption = CaptionResult(context: coreDataManager.context)
            newCaption.resultId = _uuid
            newCaption.caption = _result
            newCaption.like = _like
            
            coreDataManager.save() // 변경사항 저장
            
            print("Caption 새로 저장 완료!\n resultId : \(_uuid)\n Date : \(newCaption.date)\n Category : \(newCaption.category)\n Caption : \(newCaption.caption)\nisLike : \(_like)")
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
            
            print("Hashtag 수정 완료!\n resultId : \(existingCaptionResult.resultId)\n Date : \(existingCaptionResult.date)\nHashtag : \(existingCaptionResult.hashtag)\nisLike : \(_like)")
        } else {
            // UUID에 해당하는 데이터가 없을 경우 새로운 데이터 생성
            let newCaption = HashtagData(context: coreDataManager.context)
            newCaption.resultId = _uuid
            newCaption.hashtag = _result
            newCaption.like = _like
            
            coreDataManager.save() // 변경사항 저장
            
            print("Hashtag 수정 완료!\n resultId : \(newCaption.resultId)\n Date : \(newCaption.date)\nHashtag : \(newCaption.hashtag)\nisLike : \(_like)")
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

