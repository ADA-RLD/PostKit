//
//  BrowShopViewModel.swift
//  PostKit
//
//  Created by 김다빈 on 3/6/24.
//

import Foundation
import Combine
import UIKit

extension BrowShopView {
    // MARK: - Chat Gpt API에 응답 요청
    func sendMessage(firstSegmentSelected: Array<String>, secondSegmentSelected: Array<String>, thirdSegmentSelected: Array<String>, customKeywords: Array<String>, textLength: Int) {
        Task {
            createPrompt(firstSegmentSelectd: firstSegmentSelected,
                         secondSegmentSelected: secondSegmentSelected,
                         thirdSegmentSelected: thirdSegmentSelected,
                            customKeywords: customKeywords,
                            textLength: textLength)
            await createCaption()
        }
    }
    
    //MARK: - Vision API에 응답 요청
    func sendVisionMessage(firstSegmentSelected: Array<String>, secondSegmentSelected: Array<String>, thirdSegmentSelected: Array<String>, customKeywords: Array<String>, textLength: Int, images: [UIImage]) {
        Task {
            createVisionPrompt(firstSegmentSelected: firstSegmentSelected,
                               secondSegmentSelected: secondSegmentSelected, thirdSegmentSelected: thirdSegmentSelected, customKeywords: customKeywords, textLength: textLength, images: images)
            await createVisionCaption(images: images)
        }
        
    }
    
    //MARK: - Chat Gpt API에 사진을 포함한 Prompt 생성
    func createVisionPrompt(firstSegmentSelected: Array<String>, secondSegmentSelected: Array<String>, thirdSegmentSelected: Array<String>, customKeywords: Array<String>, textLength: Int, images: [UIImage]) {
        var pointText = ""
        var toneInfo = ""
        
        addImagesToMessages(images: images)
        
        for _tone in storeModel.tone {
            if _tone == "" {
                break
            }
            
            toneInfo += _tone + ","
        }
        
        if toneInfo == "" {
            toneInfo = "평범한"
        }
        else {
            toneInfo = toneInfo.substring(from: 0, to: toneInfo.count-2)
        }
        
        viewModel.basicPrompt = "너는 \(toneInfo) 말투와 주어진 사진을 기반으로 브로우샵 홍보를 위한 인스타그램 캡션을 대신 작성해주는 카피라이터야 가게의 이름은 \(storeModel.storeName)이야"
        
        if !secondSegmentSelected.isEmpty {
            pointText = "스타일은 "
            
            for i in secondSegmentSelected.indices {
                pointText = pointText + "\(secondSegmentSelected[i]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count - 2)
            pointText = pointText + "이 있어"
            
            if !firstSegmentSelected.isEmpty {
                pointText += "스타일의 특징으로는 "
                
                for i in firstSegmentSelected.indices {
                    pointText += "\(firstSegmentSelected[i]), "
                }
                
                pointText = pointText.substring(from: 0, to: pointText.count - 2)
                pointText = pointText + "가 있어"
            }
            
        }
        
        if !firstSegmentSelected.isEmpty && secondSegmentSelected.isEmpty {
            pointText = "브로우샵의 특징은"
            
            for i in firstSegmentSelected.indices {
                pointText = pointText + "\(firstSegmentSelected[i]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count - 2)
            pointText = pointText + "이 있어"
            
        }
        
        if !thirdSegmentSelected.isEmpty {
            pointText = "일상 키워드는"
            
            for i in thirdSegmentSelected.indices {
                pointText = pointText + "\(thirdSegmentSelected[i]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count - 2)
            pointText = pointText + "이 있어"
        }
        
        if !customKeywords.isEmpty {
            pointText = "다른 키워드는"
            
            for i in customKeywords.indices {
                pointText = pointText + "\(customKeywords[i]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count - 2)
            pointText = pointText + "이 있어"
        }
        
        viewModel.prompt = "다음 문장들과 보내준 이미지를 기반으로 브로우샵 홍보를 위한 인스타그램 캡션을 작성해줘 \(pointText) 글자수는 공백 포함해서 꼭 \(textLength)자로 맞춰주고 인스타그램에 바로 복사붙혀넣기 할 수 있게 캡션만 보내줘"
    }
    
    //MARK: - 이미지가 없는 Prompt 생성
    func createPrompt(firstSegmentSelectd: Array<String>, secondSegmentSelected: Array<String>, thirdSegmentSelected: Array<String>, customKeywords: Array<String>, textLength: Int) {
        var pointText = ""
        var toneInfo = ""
        
        for _tone in storeModel.tone {
            if _tone == "" {
                break
            }
            
            toneInfo += _tone + ","
        }
        
        if toneInfo == "" {
            toneInfo = "평범한"
        }
        else {
            toneInfo = toneInfo.substring(from: 0, to: toneInfo.count-2)
        }
        
        viewModel.basicPrompt = "너는 \(toneInfo) 말투로 브로우샵 홍보를 위한 인스타 그램 캡션을 대신 작성해주는 카피라이터야 가게의 이름은 \(storeModel.storeName)이야"
        
        if !secondSegmentSelected.isEmpty {
            pointText = "스타일은 "
            
            for i in secondSegmentSelected.indices {
                pointText = pointText + "\(secondSegmentSelected[i]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count - 2)
            pointText = pointText + "이 있어"
            
            if !firstSegmentSelectd.isEmpty {
                pointText += "스타일의 특징으로는 "
                
                for i in firstSegmentSelectd.indices {
                    pointText += "\(firstSegmentSelectd[i]), "
                }
                
                pointText = pointText.substring(from: 0, to: pointText.count - 2)
                pointText = pointText + "가 있어"
            }
            
        }
        
        if !firstSegmentSelectd.isEmpty && secondSegmentSelected.isEmpty {
            pointText = "브로우샵의 특징은"
            
            for i in firstSegmentSelectd.indices {
                pointText = pointText + "\(firstSegmentSelectd[i]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count - 2)
            pointText = pointText + "이 있어"
            
        }
        
        if !thirdSegmentSelected.isEmpty {
            pointText = "일상 키워드는"
            
            for i in thirdSegmentSelected.indices {
                pointText = pointText + "\(thirdSegmentSelected[i]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count - 2)
            pointText = pointText + "이 있어"
        }
        
        if !customKeywords.isEmpty {
            pointText = "다른 키워드는"
            
            for i in customKeywords.indices {
                pointText = pointText + "\(customKeywords[i]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count - 2)
            pointText = pointText + "이 있어"
        }
        
        viewModel.prompt = "다음 문장들을 기반으로 브로우샵 홍보를 위한 인스타그램 캡션을 작성해줘 \(pointText) 글자수는 공백 포함해서 꼭 \(textLength)자로 맞춰주고 인스타그램에 바로 복사붙혀넣기 할 수 있게 캡션만 보내줘"
    }
    
    
    
    //MARK: - Caption 생성
    func createCaption() async {
        let apiManager = APIManager()
        
        apiManager.sendKeyWord(basicPrompt: viewModel.basicPrompt, prompt: viewModel.prompt)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    loadingModel.isCaptionGenerate = true
                    pathManager.path.append(.ErrorResultFailed)
                case .finished:
                    pathManager.path.append(.CaptionResult)
                    coinManager.coinCaptionUse()
                    loadingModel.isCaptionGenerate = false
                }
            }, receiveValue: { response in
                guard let textResponse = response.captionResult else {return}
                
                viewModel.promptAnswer = textResponse
                viewModel.category = "브로우샵"
            })
            .store(in: &cancellables)
        
    }
    
    //MARK: - 이미지를 포함한 검색의 Caption 생성
    func createVisionCaption(images: [UIImage]) {
        let apiManager = APIManager()
        let imageURL = addImagesToMessages(images: images)
        
        apiManager.sendImageKeyWord(basicPrompt: viewModel.basicPrompt, prompt: viewModel.prompt, imageURL: imageURL ?? "")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    loadingModel.isCaptionGenerate = false
                    print("Caption 생성이 무사히 완료되었습니다.")
                    pathManager.path.append(.CaptionResult)
                    coinManager.coinCaptionUse()
                case .failure(let error):
                    loadingModel.isCaptionGenerate = true
                    if error._code == 10 {
                        pathManager.path.append(.ErrorResultFailed)
                    } else if error._code == 13 {
                        pathManager.path.append(.ErrorNetwork)
                    }
                }},
                  receiveValue: { response in
                guard let textResponse = response.captionResult else {return}
                
                viewModel.imageURL = imageURL ?? ""
                viewModel.promptAnswer = textResponse
                viewModel.category = "브로우샵"
                
            })
            .store(in: &cancellables)
        
    }
    
    //MARK: 이미지를 GPT 메세지에 추가하는 함수
    private func addImagesToMessages(images: [UIImage]) -> String? {
        if let firstImage = images.first,
           let imageData = firstImage.jpegData(compressionQuality: 0.5) {
            let base64String = imageData.base64EncodedString()
            let imageURL = "data:image/jpeg;base64,\(base64String)"
            return imageURL
        }
        return ""
    }
}
