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
    @Published var firstSegmentSelected: [String] = []
    @Published var secondSegmentSelected: [String] = []
    @Published var thirdSegmentSelected: [String] = []
    @Published var customKeyword: [String] = []
    @Published var cancellabes = Set<AnyCancellable>()
    @Published var selectedImage: [UIImage] = []
    @Published var selectedImageUrl: URL?
    @Published var selectedImageFileName : String?
    @Published var textLength: Int = 200
    @Published var promptAnswer: String = ""
    @Published var basicPrompt: String = ""
    @Published var prompt: String = ""
    
    func checkConditions() {
        if !(self.selectedImage.isEmpty && self.selectedKeywords.isEmpty) {
            self.isButtonEnabled = true
        }
        else {
            self.isButtonEnabled = false
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
    
    func sendVisionMessage() {
        
    }
    
    func sendMessage() {
        
    }
    
    func createCaption() async {
        
    }
    
    func createVisionCaption() async {
        
    }
}
