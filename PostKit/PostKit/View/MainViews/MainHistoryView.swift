//
//  MainHistoryView.swift
//  PostKit
//
//  Created by 김다빈 on 11/6/23.
//

import SwiftUI
import CoreData

struct MainHistoryView: View {
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @State var historySelected = "피드 글"
    @State private var captions: [CaptionModel] = []
    @State private var isShowingToast = false
    @State private var isCaptionChange = false
    @State private var showModal = false
    @State private var hashtags: [HashtagModel] = []
    @Namespace var nameSpace
    
    private let hapticManger = HapticManager.instance
    private let pasteBoard = UIPasteboard.general
    
    //CoreData Manager
    private let coreDataManager = CoreDataManager.instance
    
    var body: some View {
        ContentArea {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("히스토리")
                        .title1(textColor: .gray6)
                    
                    Text("히스토리를 탭하면 내용이 복사됩니다.")
                        .body2Bold(textColor: .gray4)
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
}

extension MainHistoryView {
    private var historyIndicator: some View {
        HStack(spacing: 16) {
            
            Button(action: {
                withAnimation(.spring(response: 0.5,dampingFraction: 0.8)) {
                    historySelected = "피드 글"
                }
            }, label: {
                Text("피드 글")
                    .title2(textColor: .gray6)
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
                    .title2(textColor: .gray6)
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
        .onAppear {
            fetchCaptionData()
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
        .onAppear {
            fetchHashtagData()
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
                            .body2Bold(textColor: .white)
                            .padding(.horizontal, 9.5)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .background(Color.main)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(.clear)
                            }
                        Spacer()
                        Text(date)
                            .body2Bold(textColor: .gray4)
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
                        .body2Bold(textColor: .gray5)
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
                            .body2Bold(textColor: .gray4)
                        
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
                        .body2Bold(textColor: .gray5)
                    
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


