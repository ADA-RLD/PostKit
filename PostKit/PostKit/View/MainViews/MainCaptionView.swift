//
//  MainCaptionView.swift
//  PostKit
//
//  Created by 김다빈 on 11/6/23.
//

import SwiftUI
import CoreData
import Mixpanel

struct MainCaptionView: View {
    @EnvironmentObject var pathManager: PathManager
    @ObservedObject var coinManager = CoinManager.shared
    
    @StateObject var storeModel = StoreModel( _storeName: "", _tone: [])
    @State private var timeRemaining : Int = 0
    
    var remainingTime = "04:32" // TODO: 24시까지 남은 시간으로 변경
    
    private let coreDataManager = CoreDataManager.instance
    private let hapticManger = HapticManager.instance
    private let coinMax = 10
    private let date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                    //hashtagArea()
                }
                
                Spacer()
            }
        }
        .onAppear{
            calcRemain()
            checkDate()
        }
    }
}

extension MainCaptionView {
    func convertSecondsToTime(timeInSeconds: Int) -> String {
        let hours = timeInSeconds / 3600
        let minutes = (timeInSeconds - hours * 3600) / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func calcRemain() {
        let formatterHour = DateFormatter()
        formatterHour.dateFormat = "HH"
        let currentHour = formatterHour.string(from: Date())
        
        let formatterMinute = DateFormatter()
        formatterMinute.dateFormat = "mm"
        let currentMinute = formatterMinute.string(from: Date())
        
        let formatterSecond = DateFormatter()
        formatterSecond.dateFormat = "ss"
        let currentSecond = formatterSecond.string(from: Date())
        
        let hour = 24 - (Int(currentHour) ?? 0)
        let minute = (Int(currentMinute) ?? 0)
        let second = (Int(currentSecond) ?? 0)
        
        self.timeRemaining = (hour * 60 - minute) * 60 - second
    }
    
    func checkDate() {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy.MM.dd"
        let currentDay = formatterDate.string(from: Date())
        
        if currentDay != coinManager.date {
            coinManager.date = currentDay
            coinManager.coin = CoinManager.maximalCoin
            print("코인이 초기화 되었습니다.")
        }
    }
}

extension MainCaptionView {
    
    private func coinArea() -> some View {
        HStack {
            HStack(spacing: 8.0) {
                Image(.coin)
                Text("\(coinManager.coin)/\(coinMax)")
                    .body2Bold(textColor: .gray5)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .overlay(
                RoundedRectangle(cornerRadius: radius1)
                    .stroke(Color.gray2, lineWidth: 1)
            )
            
            Spacer()
            
            HStack(spacing: 4.0) {
                Text("무료 충전까지")
                    .body2Bold(textColor: .gray3)
                Text(convertSecondsToTime(timeInSeconds:timeRemaining))
                    .body2Bold(textColor: .gray4)
                    .multilineTextAlignment(.trailing)
                    .onReceive(timer) { _ in
                        timeRemaining -= 1
                        checkDate()
                    }
                    .frame(width: 60) // 숫자가 바뀌며 무료 충전 텍스트의 위치가 바뀌어서 임의의 값을 지정해두었습니다.
            }
        }
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
                categoryBtn(categoryImage: "visionpro", categoryName: "일상", for: .cafe, action: {pathManager.path.append(.Daily)
                    Mixpanel.mainInstance().track(event: "카테고리 선택", properties:["카테고리": "일상"])})
                categoryBtn(categoryImage: "visionpro", categoryName: "메뉴",for: .cafe, action: {pathManager.path.append(.Menu)
                    Mixpanel.mainInstance().track(event: "카테고리 선택", properties:["카테고리": "메뉴"])})
                categoryBtn(categoryImage: "visionpro", categoryName: "상품", for: .fassion, action: {pathManager.path.append(.Goods)
                    Mixpanel.mainInstance().track(event: "카테고리 선택", properties:["카테고리": "쇼핑"])})
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
            categoryBtn(categoryImage: "eye", categoryName: "해시태그", for: .cafe, action: {pathManager.path.append(.Hashtag)
                        Mixpanel.mainInstance().track(event: "카테고리 선택", properties:["카테고리": "해시태그"])})
        }
    }

    private func categoryBtn(categoryImage: String, categoryName: String, for type: categoryType, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: categoryName)
                
                Text(categoryName)
                    .body1Bold(textColor: .gray5)
                
                Spacer()
                
                categoryTag(for: type)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color.sub)
            .cornerRadius(radius1)
        }
    }
    
    private func categoryTag(for type: categoryType) -> some View {
        Text(type == .cafe ? "카페" : "패션")
            .body2Bold(textColor: type == .cafe ? Color.categoryTextRed : Color.categoryTextBlue )
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(type == .cafe ? Color.categoryBgRed : Color.categoryBgBlue)
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
                self.storeModel.tone = storeCoreData.tones ?? []
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
