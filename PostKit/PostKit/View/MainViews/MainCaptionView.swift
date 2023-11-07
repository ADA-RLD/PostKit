//
//  MainCaptionView.swift
//  PostKit
//
//  Created by 김다빈 on 11/6/23.
//

import SwiftUI
import CoreData

struct MainCaptionView: View {
    @EnvironmentObject var pathManager: PathManager
    @ObservedObject var coinManager = CoinManager.shared
    @StateObject var storeModel = StoreModel( _storeName: "", _tone: ["기본"])
    var remainingTime = "04:32" // TODO: 24시까지 남은 시간으로 변경
    
    private let coreDataManager = CoreDataManager.instance
    private let hapticManger = HapticManager.instance
    private let coinMax = 10
    
    var body: some View {
        ContentArea {
            VStack(alignment: .leading, spacing: 28) {
                HStack {
                    Text("글 쓰기")
                        .title1(textColor: .gray6)
                    Spacer()
                    SettingBtn(action: {pathManager.path.append(.SettingHome)})
                }
                
                coinArea()
                
                VStack(alignment: .leading, spacing: 52) {
                    captionArea()
                    hashtagArea()
                }
                
                Spacer()
            }
        }
    }
}

extension MainCaptionView {
    
    private func coinArea() -> some View {
        HStack(spacing: 8.0) {
            Image(.coin)
            Text("\(coinManager.coin)/\(coinMax)")
                .body2Bold(textColor: .gray5)
            Text("\(remainingTime)")
                .body2Bold(textColor: .gray3)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .overlay(
            RoundedRectangle(cornerRadius: radius1)
                .stroke(Color.gray2, lineWidth: 1)
        )
    }
    
    private func captionArea() -> some View {
        VStack(alignment: .leading, spacing: 20.0){
            HStack(spacing: 12.0) {
                Text("피드 글")
                    .title2(textColor: .gray5)
                HStack(spacing: 6.0) {
                    Image(.coin)
                    Text("2개")
                        .body2Bold(textColor: .gray4)
                }
            }
            
            VStack(spacing: 12.0) {
                categoryBtn(categoryName: "일상", categoryDescription: "보편적인 일상 피드 글", categoryImage: Image(.daily), action: {pathManager.path.append(.Daily)})
                categoryBtn(categoryName: "메뉴", categoryDescription: "메뉴를 소개하는 피드 글", categoryImage: Image(.menu), action: {pathManager.path.append(.Menu)})
            }
        }
    }
    
    private func hashtagArea() -> some View {
        VStack(alignment: .leading, spacing: 20.0){
            HStack(spacing: 12.0) {
                Text("해시태그")
                    .title2(textColor: .gray5)
                HStack(spacing: 6.0) {
                    Image(.coin)
                    Text("1개")
                        .body2Bold(textColor: .gray4)
                }
            }
            
            categoryBtn(categoryName: "해시태그", categoryDescription: "우리 매장에 딱 맞는 해시태그", categoryImage: Image(.hashtag), action: {pathManager.path.append(.Hashtag)})
        }
    }

    private func categoryBtn(categoryName: String, categoryDescription: String, categoryImage: Image, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(categoryName)
                        .body1Bold(textColor: .gray6)
                    Text(categoryDescription)
                        .body2Bold(textColor: .gray4)
                }
                Spacer()
                categoryImage
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(Color.sub)
            .cornerRadius(radius1)
        }
    }
    
    private func SettingBtn(action: @escaping () -> Void) -> some View {
        HStack(alignment: .center) {
            Spacer()
            Button(action: {
                action()
            }, label: {
                Image(.gearShape)
            })
        }
    }
}


extension MainCaptionView : MainViewProtocol {
    
    func fetchStoreData() {
        let storeRequest = NSFetchRequest<StoreData>(entityName: "StoreData")

        do {
            let storeDataArray = try coreDataManager.context.fetch(storeRequest)
            if let storeCoreData = storeDataArray.last {
                self.storeModel.storeName = storeCoreData.storeName ?? ""
                self.storeModel.tone = storeCoreData.tones ?? ["기본"]
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func fetchCaptionData() {
       // 여기서 안씁니다.
    }
    
    func fetchHashtagData() {
      // 여기서 안써요..
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

#Preview {
    MainCaptionView()
}
