//
//  HairViewModel.swift
//  PostKit
//
//  Created by Kim Andrew on 3/5/24.
//

import Foundation
import UIKit

extension HairView {
    // MARK: - Chat Gpt API에 응답 요청
    func sendMessage(coffeeSelected: Array<String>, dessertSelected: Array<String>, drinkSelected: Array<String>, menuName: String, customKeywords: Array<String>, textLenth: Int){
        Task{
            createPrompt(coffeeSelected: coffeeSelected, dessertSelected: dessertSelected, drinkSelected: drinkSelected, customKeywords: customKeywords, menuName: menuName, textLength: textLenth)
            await createCaption()
        }
    }
    
    // MARK: - Vision API에 응답 요청
    func sendVisionMessage(coffeeSelected: Array<String>, dessertSelected: Array<String>, drinkSelected: Array<String>, menuName: String, customKeywords: Array<String>, textLenth: Int, images: [UIImage]){
        Task{
            createPrompt(coffeeSelected: coffeeSelected, dessertSelected: dessertSelected, drinkSelected: drinkSelected, customKeywords: customKeywords, menuName: menuName, textLength: textLenth)
            viewModel.prompt += "상품의 사진은 다음과 같아"
            await createVisionCaption(images: images)
        }
    }

    // MARK: - Prompt 생성
    func createPrompt(coffeeSelected: Array<String>, dessertSelected: Array<String>, drinkSelected: Array<String>, customKeywords: Array<String>, menuName: String, textLength: Int){
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
        
        viewModel.basicPrompt = "너는 \(storeModel.storeName)를 운영하고 있으며 \(toneInfo) 말투를 가지고 있어. 글은 존댓말로 작성해줘. 다른 부연 설명은 하지 말고 응답 내용만 작성해줘. 글자수는 꼭 \(textLength)자로 맞춰서 작성해줘."
        print(viewModel.basicPrompt)
        
        if !coffeeSelected.isEmpty {
            pointText = pointText + "이 상품의 종류는 "
            
            for index in coffeeSelected.indices {
                pointText = pointText + "\(coffeeSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        else if !drinkSelected.isEmpty {
            pointText = pointText + "이 상품의 특징으로는 "
            
            for index in drinkSelected.indices {
                pointText = pointText + "\(drinkSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        else if !dessertSelected.isEmpty {
            pointText = pointText + "이 상품의 재질은 "
            
            for index in dessertSelected.indices {
                pointText = pointText + "\(dessertSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        if !customKeywords.isEmpty {
            pointText = pointText + "특징으로는 "
            
            for index in customKeywords.indices {
                pointText = pointText + "\(customKeywords[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        viewModel.prompt = "인스타그램 피드를 글자수는 공백 포함해서 꼭 \(textLength)자로 맞춰서 작성해줘. \(pointText)"
    }
    
    // MARK: - Caption 생성
    func createCaption() async {
        let apiManager = APIManager()
        
        apiManager.sendKeyWord(basicPrompt: viewModel.basicPrompt, prompt: viewModel.prompt)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    loadingModel.isCaptionGenerate = true
                    pathManager.path.append(.ErrorResultFailed)
                    print(viewModel.prompt)
                    
                    
                case .finished:
                    pathManager.path.append(.CaptionResult)
                    coinManager.coinCaptionUse()
                    loadingModel.isCaptionGenerate = false
                    print("Caption 생성 완료")
                }
                
            }, receiveValue: { response in
                guard let textResponse = response.captionResult else {return}
                
                viewModel.promptAnswer = textResponse
                viewModel.category = "상품"
            })
            .store(in: &cancellables)
    }
    
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
                    print("error 발생. error code: \(error._code)")
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
                viewModel.category = "일상"
                
            })
            .store(in: &cancellables)
    }

    // MARK: 이미지를 GPT 메세지에 추가하는 함수
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


