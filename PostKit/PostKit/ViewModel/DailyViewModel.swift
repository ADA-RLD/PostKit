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
        
        viewModel.basicPrompt = "너는 \(storeModel.storeName)를 운영하고 있으며 \(toneInfo) 말투를 가지고 있어. 그리고 같이 보낸 사진에 대해서도 설명해줘 글은 존댓말로 작성해줘. 다른 부연 설명은 하지 말고 응답 내용만 작성해줘. 글자수는 꼭 \(textLength)자로 맞춰서 작성해줘."
        print(viewModel.basicPrompt)
        self.messages.append(Message(id: UUID(), role: .system, content: viewModel.basicPrompt))
        
        if !weatherSelected.isEmpty {
            pointText = pointText + "오늘 날씨의 특징으로는 "
            
            for index in weatherSelected.indices {
                pointText = pointText + "\(weatherSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        if !dailyCoffeeSelected.isEmpty {
            pointText = pointText + "오늘 이야기하고자 하는 음료는 "
            
            for index in dailyCoffeeSelected.indices {
                pointText = pointText + "\(dailyCoffeeSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        if !dailyDessertSelected.isEmpty {
            pointText = pointText + "오늘 이야기하고자 하는 디저트는 "
            
            for index in dailyDessertSelected.indices {
                pointText = pointText + "\(dailyDessertSelected[index]), "
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
        
        viewModel.prompt = "보내준 사진에 대한 설명과 카페 일상과 관련된 인스타그램 피드를 해시태그 없이 작성해줘.  \(pointText) 글자수는 공백 포함해서 꼭 \(textLength)자로 맞춰서 작성해줘."
        self.visionMessages.append(GptVisionMessage( role: .user, content: .array([GptVisionContent(type: "text", text: viewModel.prompt, image_url: nil)])))

   
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
        
        viewModel.basicPrompt = "너는 \(storeModel.storeName)를 운영하고 있으며 \(toneInfo) 말투를 가지고 있어. 글은 존댓말로 작성해줘. 다른 부연 설명은 하지 말고 응답 내용만 작성해줘. 글자수는 꼭 \(textLength)자로 맞춰서 작성해줘."
        print(viewModel.basicPrompt)
        self.messages.append(Message(id: UUID(), role: .system, content: viewModel.basicPrompt))
        
        if !weatherSelected.isEmpty {
            pointText = pointText + "오늘 날씨의 특징으로는 "
            
            for index in weatherSelected.indices {
                pointText = pointText + "\(weatherSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        if !dailyCoffeeSelected.isEmpty {
            pointText = pointText + "오늘 이야기하고자 하는 음료는 "
            
            for index in dailyCoffeeSelected.indices {
                pointText = pointText + "\(dailyCoffeeSelected[index]), "
            }
            
            pointText = pointText.substring(from: 0, to: pointText.count-2)
            pointText = pointText + "이 있어."
        }
        
        if !dailyDessertSelected.isEmpty {
            pointText = pointText + "오늘 이야기하고자 하는 디저트는 "
            
            for index in dailyDessertSelected.indices {
                pointText = pointText + "\(dailyDessertSelected[index]), "
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
        
        viewModel.prompt = "카페 일상과 관련된 인스타그램 피드를 해시태그 없이 작성해줘. \(pointText) 글자수는 공백 포함해서 꼭 \(textLength)자로 맞춰서 작성해줘."
        self.messages.append(Message(id: UUID(), role: .user, content: viewModel.prompt))
    }
    
    // MARK: - Caption 생성
    func createCaption() async {
        let chatGptService = ChatGptService()
        
        chatGptService.sendMessage(messages: self.messages)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        loadingModel.isCaptionGenerate = true
                        print("error 발생. error code: \(error._code)")
                        if error._code == 10 {
                            pathManager.path.append(.ErrorResultFailed)
                        }
                        else if error._code == 13 {
                            pathManager.path.append(.ErrorNetwork)
                        }
                    case .finished:
                        loadingModel.isCaptionGenerate = false
                        print("Caption 생성이 무사히 완료되었습니다.")
                        pathManager.path.append(.CaptionResult)
                        coinManager.coinCaptionUse()
                    }
                },
                receiveValue:  { response in
                    guard let textResponse = response.choices.first?.message.content else {return}
                    
                    viewModel.promptAnswer = textResponse
                    viewModel.category = "일상"
                }
            )
            .store(in: &cancellables)
    }
    
    func createVisionCaption(images: [UIImage]) {
        let chatGptVisionService = GptVisionService()
        
        addImagesToMessages(images: images)
        
        chatGptVisionService.sendMessage(messages: self.visionMessages)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        loadingModel.isCaptionGenerate = true
                        print("error 발생. error code: \(error._code)")
                        if error._code == 10 {
                            pathManager.path.append(.ErrorResultFailed)
                        } else if error._code == 13 {
                            pathManager.path.append(.ErrorNetwork)
                        }
                    case .finished:
                        loadingModel.isCaptionGenerate = false
                        print("Caption 생성이 무사히 완료되었습니다.")
                        pathManager.path.append(.CaptionResult)
                        coinManager.coinCaptionUse()
                    }
                },
                receiveValue: { response in
                    guard let choice = response.choices.first else { return }

                    // 선택지의 메시지를 가져옵니다.
                    let message = choice.message

                    // 메시지에서 content를 가져옵니다.
                    let content = message.content

                    // content가 .string 케이스인 경우에 대한 처리
                    if case let .string(text) = content {
                        viewModel.promptAnswer = text
                    }

                    viewModel.category = "일상"
                }

            )
            .store(in: &cancellables)

    }

    // MARK: 이미지를 GPT 메세지에 추가하는 함수
    private func addImagesToMessages(images: [UIImage]) {
        for image in images {
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                let base64String = imageData.base64EncodedString()
                let imageUrl = "data:image/jpeg;base64,\(base64String)"
                let imageContent = GptVisionContent(type: "image_url", text: nil, image_url: ImageURL(url: imageUrl))
                let message = GptVisionMessage(role: .user, content: .array([imageContent]))
                visionMessages.append(message)
            }
        }
    }
}
