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
    
    private let coreDataManager = CoreDataManager.instance
    private let hapticManger = HapticManager.instance
    
    var body: some View {
        ContentArea {
            VStack(alignment:.leading ,spacing: 28) {
                SettingBtn(action: {pathManager.path.append(.SettingHome)})
                
                VStack(alignment: .leading, spacing: 28) {
                    
                    Text("\(coinManager.coin)")
                    
                    Text("어떤 카피를 생성할까요?")
                        .title1(textColor: .gray6)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        captionArea()
                        hashtagArea()
                    }
                }
                Spacer()
            }
        }
    }
}

extension MainCaptionView {
    
    private func captionArea() -> some View {
        RoundedRectangle(cornerRadius: radius1)
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.sub)
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("캡션")
                            .title2(textColor: .gray6)

                        Text("카페의 메뉴에 대한 글을 써요")
                            .body2Bold(textColor: .gray4)
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
                            .title2(textColor: .gray6)
                        
                        Text("우리 카페에는 어떤 해시태그가 어울릴까?")
                            .body2Bold(textColor: .gray4)
                    }
                    .padding(.vertical,28)
                    .padding(.horizontal,16)
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
                        .body1Bold(textColor: .gray5)
                }
        }
    }
    
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
}


extension MainCaptionView : MainViewProtocol {
    
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
