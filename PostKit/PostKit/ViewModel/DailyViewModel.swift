//
//  DailyViewModel.swift
//  PostKit
//
//  Created by doeun kim on 11/1/23.
//

import Foundation
import Combine
import UIKit

extension DailyView {
    // MARK: - Chat Gpt API에 응답 요청
    func sendMessage(weatherSelected: Array<String>, dailyCoffeeSelected: Array<String>, dailyDessertSelected: Array<String>, customKeywords: Array<String>, textLength: Int) {
        Task{
            createPrompt(weatherSelected: weatherSelected, dailyCoffeeSelected: dailyCoffeeSelected, dailyDessertSelected: dailyDessertSelected, customKeywords: customKeywords, textLength: textLength)
            await createCaption()
        }
    }
    
    // MARK: - Vision API에 응답 요청
    func sendVisionMessage(weatherSelected: [String], dailyCoffeeSelected: [String], dailyDessertSelected: [String], customKeywords: [String], textLength: Int, images: [UIImage]) {
        Task {
            createVisionPrompt(weatherSelected: weatherSelected, dailyCoffeeSelected: dailyCoffeeSelected, dailyDessertSelected: dailyDessertSelected, customKeywords: customKeywords, textLength: textLength, images: images)
            await createVisionCaption(images: images)
        }
    }

    // MARK: - Chat Gpt API에 사진을 포함한 Prompt 생성
    func createVisionPrompt(weatherSelected: Array<String>, dailyCoffeeSelected: Array<String>, dailyDessertSelected: Array<String>, customKeywords: Array<String>, textLength: Int, images: [UIImage]) {
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
        
        viewModel.basicPrompt = "너는 \(toneInfo) 말투와 사진을 기반으로 카페 홍보를 위한 인스타 그램 캡션을 대신 작성해주는 카피라이터야 가게의 이름은 \(storeModel.storeName)이야"

        
        if !weatherSelected.isEmpty {
            pointText = pointText + "날씨 키워드는 "
            
            for index in weatherSelected.indices {
                pointText = pointText + "\(weatherSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        if !dailyCoffeeSelected.isEmpty {
            pointText = pointText + "음료수 키워드는 "
            
            for index in dailyCoffeeSelected.indices {
                pointText = pointText + "\(dailyCoffeeSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        if !dailyDessertSelected.isEmpty {
            pointText = pointText + "디저트 키워드는 "
            
            for index in dailyDessertSelected.indices {
                pointText = pointText + "\(dailyDessertSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "가 있어."
        }
        
        if !customKeywords.isEmpty {
            pointText = pointText + "기타 키워드는 "
            
            for index in customKeywords.indices {
                pointText = pointText + "\(customKeywords[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        viewModel.prompt = "다음의 키워드와 사진을 기반으로 캡션을 작성해줘. \(pointText) 글자수는 공백 포함해서 꼭 \(textLength)자로 맞춰서 작성해고 인스타그램에 바로 복사붙혀넣기 할 수 있게 캡션만 보내줘."
    }
    
    // MARK: - Prompt 생성
    func createPrompt(weatherSelected: Array<String>, dailyCoffeeSelected: Array<String>, dailyDessertSelected: Array<String>, customKeywords: Array<String>, textLength: Int){
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
        
        viewModel.basicPrompt = "너는 \(toneInfo) 말투로 카페 홍보를 위한 인스타 그램 캡션을 대신 작성해주는 카피라이터야 가게의 이름은 \(storeModel.storeName)이야"
        
        if !weatherSelected.isEmpty {
            pointText = pointText + "음료 키워드로는"
            
            for index in weatherSelected.indices {
                pointText = pointText + "\(weatherSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        if !dailyCoffeeSelected.isEmpty {
            pointText = pointText + "디저트 키워드로는 "
            
            for index in dailyCoffeeSelected.indices {
                pointText = pointText + "\(dailyCoffeeSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        if !dailyDessertSelected.isEmpty {
            pointText = pointText + "일상 키워드로는 "
            
            for index in dailyDessertSelected.indices {
                pointText = pointText + "\(dailyDessertSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        if !customKeywords.isEmpty {
            pointText = pointText + "기타 키워드로는 "
            
            for index in customKeywords.indices {
                pointText = pointText + "\(customKeywords[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        viewModel.prompt = "다음 키워드들을 포함해서 카페 홍보를 위한 인스타그램 캡션만 작성해줘. \(pointText) 글자수는 공백 포함해서 꼭 \(textLength)자로 맞춰주고 인스타그램에 바로 복사붙혀넣기 할 수 있게 캡션만 보내줘."
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
                    traceLog(viewModel.prompt)
                    
                    
                case .finished:
                    pathManager.path.append(.CaptionResult)
                    coinManager.coinCaptionUse()
                    loadingModel.isCaptionGenerate = false
                    traceLog(viewModel.prompt)
                }
                
            }, receiveValue: { response in
                guard let textResponse = response.captionResult else {return}
                
                viewModel.promptAnswer = textResponse
                viewModel.category = "카페"
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
