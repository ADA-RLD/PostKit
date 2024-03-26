//
//  CaptionViewModel.swift
//  PostKit
//
//  Created by 김다빈 on 3/23/24.
//

import Foundation
import CoreData
import Combine
import Mixpanel
import SwiftUI


class CaptionViewModel: ObservableObject {
    @Published var isButtonEnabled: Bool = false
    @Published var isKeywordModal: Bool = false
    @Published var isOpenPhoto: Bool = false
    @Published var coinAlert: Bool = false
    @Published var selectedKeywords: [String] = []
    @Published var isCaptionSuccess: Bool = false
    @Published var errorCode: Int = 0
    @Published var firstSegmentSelected: [String] = []
    @Published var secondSegmentSelected: [String] = []
    @Published var thirdSegmentSelected: [String] = []
    @Published var customKeyword: [String] = []
    @Published var cancellabes = Set<AnyCancellable>()
    @Published var selectedImage: [UIImage] = []
    @Published var selectedImageUrl: URL?
    @Published var selectedImageFileName : String?
    @Published var textLength: Int = 200
    @Published var categoryName: String = ""
    @Published var promptAnswer: String = ""
    @Published var basicPrompt: String = ""
    @Published var prompt: String = ""
    
    static let shared = CaptionViewModel()
    
    func checkConditions() {
        if !(self.selectedImage.isEmpty && self.selectedKeywords.isEmpty) {
            self.isButtonEnabled = true
        }
        else {
            self.isButtonEnabled = false
        }
    }
    
    func checkCategory(category: String) {
        DispatchQueue.main.async {
            self.categoryName = category
        }
    }
    
    func deleteKeywords(keywords: String) {
        if firstSegmentSelected.contains(keywords) {
            self.firstSegmentSelected.removeAll(where: {$0 == keywords})
            self.selectedKeywords.removeAll(where: {$0 == keywords})
        }
        else if secondSegmentSelected.contains(keywords) {
            self.secondSegmentSelected.removeAll(where: {$0 == keywords})
            self.selectedKeywords.removeAll(where: {$0 == keywords})
        }
        else if thirdSegmentSelected.contains(keywords) {
            self.thirdSegmentSelected.removeAll(where: {$0 == keywords})
            self.selectedKeywords.removeAll(where: {$0 == keywords})
        }
        else if customKeyword.contains(keywords) {
            self.customKeyword.removeAll(where: {$0 == keywords})
            self.selectedKeywords.removeAll(where: {$0 == keywords})
        }
        
    }
    
    func createVisionPrompt(storeName: String, storeInfo: String, toneInfo: [String], segmentInfo: [String]) {
        var pointText = ""
        var tone = ""
        
        for i in toneInfo {
            if i == "" {
                break
            }
            
            tone += i + ","
        }
        
        if tone == "" {
            tone = "평범한"
        }
        
        basicPrompt = "너는 \(toneInfo) 말투와 보내준 사진을 기반으로 \(storeInfo) 홍보를 위한 인스타그램 캡션을 대신 작성해주는 카피라이터야 가게의 이름은 \(storeName)이야"
        
        if !firstSegmentSelected.isEmpty {
            pointText = pointText + "\(segmentInfo[0]) + 키워드는"
            
            for index in firstSegmentSelected.indices {
                pointText = pointText + "\(firstSegmentSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        if !secondSegmentSelected.isEmpty {
            pointText = pointText + "\(segmentInfo[1]) + 키워드는"
            
            for index in secondSegmentSelected.indices {
                pointText = pointText + "\(secondSegmentSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        if !thirdSegmentSelected.isEmpty {
            pointText = pointText + "\(segmentInfo[2]) + 키워드는"
            
            for index in thirdSegmentSelected.indices {
                pointText = pointText + "\(thirdSegmentSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        if !customKeyword.isEmpty {
            pointText = pointText + "사용자가 강조하고 싶은 키워드는"
            
            for index in customKeyword.indices {
                pointText = pointText + "\(customKeyword[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        prompt = "다음 키워드드와 보내준 사진을 기반으로 \(storeInfo) 홍보를 위한 인스타그램 캡션만 작성해줘. \(pointText) 글자수는 공백 포함해서 꼭 \(textLength)자로 맞춰주고 인스타그램에 바로 복사 붙혀넣기 할 수 있게 캡션만 보내줘."
    }
    
    func createPrompt(storeName: String, storeInfo: String, toneInfo: [String], segmentInfo: [String]) {
        var pointText = ""
        var tone = ""
        
        for i in toneInfo {
            if i == "" {
                break
            }
            
            tone += i + ","
        }
        
        if tone == "" {
            tone = "평범한"
        }
        
        basicPrompt = "너는 \(toneInfo) 말투로 \(storeInfo) 홍보를 위한 인스타그램 캡션을 대신 작성해주는 카피라이터야 가게의 이름은 \(storeName)이야"
        
        if !firstSegmentSelected.isEmpty {
            pointText = pointText + "\(segmentInfo[0]) + 키워드는"
            
            for index in firstSegmentSelected.indices {
                pointText = pointText + "\(firstSegmentSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        if !secondSegmentSelected.isEmpty {
            pointText = pointText + "\(segmentInfo[1]) + 키워드는"
            
            for index in secondSegmentSelected.indices {
                pointText = pointText + "\(secondSegmentSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        if !thirdSegmentSelected.isEmpty {
            pointText = pointText + "\(segmentInfo[2]) + 키워드는"
            
            for index in thirdSegmentSelected.indices {
                pointText = pointText + "\(thirdSegmentSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        if !customKeyword.isEmpty {
            pointText = pointText + "사용자가 강조하고 싶은 키워드는"
            
            for index in customKeyword.indices {
                pointText = pointText + "\(customKeyword[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        prompt = "다음 키워드들을 포함해서 \(storeInfo) 홍보를 위한 인스타그램 캡션만 작성해줘. \(pointText) 글자수는 공백 포함해서 꼭 \(textLength)자로 맞춰주고 인스타그램에 바로 복사 붙혀넣기 할 수 있게 캡션만 보내줘."
    }
    
    @MainActor func sendVisionMessage() {
        Task {
            await createVisionCaption()
        }
        
    }
    
    @MainActor func sendMessage()  {
        Task {
            await createCaption()
        }
        
    }
    
    func resetCondition() {
        isCaptionSuccess = false
        errorCode = 0
        selectedImage = []
        firstSegmentSelected = []
        secondSegmentSelected = []
        thirdSegmentSelected = []
        customKeyword = []
        selectedKeywords = []
    }
    
    func isImage() -> Bool {
        if selectedImage.isEmpty {
            return false
        }
        return true
    }
    
    func createCaption() {
        let apiManager = APIManager()
        
        apiManager.sendKeyWord(basicPrompt: basicPrompt, prompt: prompt)
            .sink(receiveCompletion: { completion in
                switch completion {
                case.failure(let error):
                    print("실패")
                    if error._code == 10 {
                            self.errorCode = 10
                    } else if error._code == 13 {
                            self.errorCode = 13
                    }
                case.finished:
                    print("성공")
                    DispatchQueue.main.async {
                        self.isCaptionSuccess = true
                    }
                }
                
            }, receiveValue: { response in
                guard let textResponse = response.captionResult else {return}
                    self.promptAnswer = textResponse
                    self.isCaptionSuccess = true
            })
            .store(in: &cancellabes)
    }
    
    func createVisionCaption() {
        let apiManager = APIManager()
        let imageURL = addImagesToMessages()
        print("비전캡션")
        apiManager.sendImageKeyWord(basicPrompt: basicPrompt, prompt: prompt, imageURL: imageURL ?? "")
            .sink(receiveCompletion: { completion in
                switch completion {
                case.finished:
                        self.isCaptionSuccess = true
                case.failure(let error):
                    if error._code == 10 {
                            self.errorCode = 10
                    } else if error._code == 13 {
                            self.errorCode = 13
                    }
                }
                
            }, receiveValue: { response in
                guard let textResponse = response.captionResult else {return}
                DispatchQueue.main.async {
                    print(textResponse)
                    self.promptAnswer = textResponse
                    self.isCaptionSuccess = true
                }
                
            }).store(in: &cancellabes)
    }
    
    func addImagesToMessages() -> String? {
        if let firstImage = selectedImage.first,
           let imageData = firstImage.jpegData(compressionQuality: 0.5) {
            let base64String = imageData.base64EncodedString()
            let imageURL = "data:image/jpeg;base64,\(base64String)"
            return imageURL
        }
        return ""
    }
}
