//
//  DailyViewModel.swift
//  PostKit
//
//  Created by doeun kim on 11/1/23.
//

import Foundation

extension DailyView {
    // MARK: - Chat Gpt API에 응답 요청
    func sendMessage(weatherSelected: Array<String>, dailyCoffeeSelected: Array<String>, dailyDessertSelected: Array<String>) {
        Task{
            createPrompt(weatherSelected: weatherSelected, dailyCoffeeSelected: dailyCoffeeSelected, dailyDessertSelected: dailyDessertSelected)
            self.messages.append(Message(id: UUID(), role: .user, content: self.currentInput))
            await createCaption()
        }
    }
    
    // MARK: - Prompt 생성
    func createPrompt(weatherSelected: Array<String>, dailyCoffeeSelected: Array<String>, dailyDessertSelected: Array<String>){
        var pointText = ""
        var toneInfo = ""
        
        for _tone in storeModel.tone {
            if _tone == "" {
                break
            }
            
            toneInfo += _tone + ","
        }
        
        if toneInfo == "" {
            toneInfo = "평범"
        }
        
        self.messages.append(Message(id: UUID(), role: .system, content:"너는 \(storeModel.storeName)를 운영하고 있으며 \(toneInfo)한 말투를 가지고 있어. 글은 존댓말로 작성해줘. 다른 부연 설명은 하지 말고 응답 내용만 작성해줘. 글자수는 꼭 150자 정도로 작성해줘."))
        
        print("[생성 정보]\n너는 \(storeModel.storeName)를 운영하고 있으며 \(toneInfo)한 말투를 가지고 있어. 글은 존댓말로 작성해줘. 다른 부연 설명은 하지 말고 응답 내용만 작성해줘. 글자수는 꼭 150자 정도로 작성해줘.")
        
        if !weatherSelected.isEmpty {
            pointText = pointText + "오늘 날씨의 특징으로는 "
            
            for index in weatherSelected.indices {
                pointText = pointText + "\(weatherSelected[index]), "
            }
            
            pointText = pointText + "이 있어."
        }
        
        if !dailyCoffeeSelected.isEmpty {
            pointText = pointText + "오늘 이야기하고자 하는 음료는 "
            
            for index in dailyCoffeeSelected.indices {
                pointText = pointText + "\(dailyCoffeeSelected[index]), "
            }
            
            pointText = pointText + "이 있어."
        }
        
        if !dailyDessertSelected.isEmpty {
            pointText = pointText + "오늘 이야기하고자 하는 디저트는 "
            
            for index in dailyDessertSelected.indices {
                pointText = pointText + "\(dailyDessertSelected[index]), "
            }
            
            pointText = pointText + "이 있어."
        }
        
        self.currentInput = "카페 일상과 관련된 인스타그램 피드를 해시태그 없이 작성해줘. \(pointText)"
    }
    
    // MARK: - Caption 생성
    func createCaption() async {
        viewModel.prompt = self.currentInput
        self.currentInput = ""
        let response = await chatGptService.sendMessage(messages: self.messages)
        viewModel.promptAnswer = response?.choices.first?.message.content == nil ? "" : response!.choices.first!.message.content
        viewModel.category = "일상"
        
        print(response as Any)
    }
}
