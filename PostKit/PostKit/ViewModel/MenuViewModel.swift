//
//  MenuViewModel.swift
//  PostKit
//
//  Created by doeun kim on 11/1/23.
//

import Foundation

extension MenuView {
    // MARK: - Chat Gpt API에 응답 요청
    func sendMessage(){
        Task{
            createPrompt()
            self.messages.append(Message(id: UUID(), role: .user, content: self.currentInput))
            await createCaption()
        }
    }
    
    // MARK: - Prompt 생성
    func createPrompt(){
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

        if !coffeeSelected.isEmpty {
            pointText = pointText + "이 메뉴의 특징으로는 "
            
            for index in coffeeSelected.indices {
                pointText = pointText + "\(coffeeSelected[index]), "
            }
            
            pointText = pointText + "이 있어."
        }
        else if !drinkSelected.isEmpty {
            pointText = pointText + "이 메뉴의 특징으로는 "
            
            for index in drinkSelected.indices {
                pointText = pointText + "\(drinkSelected[index]), "
            }
            
            pointText = pointText + "이 있어."
        }
        else if !dessertSelected.isEmpty {
            pointText = pointText + "이 메뉴의 특징으로는 "
            
            for index in dessertSelected.indices {
                pointText = pointText + "\(dessertSelected[index]), "
            }
            
            pointText = pointText + "이 있어."
        }
        
        self.currentInput = "메뉴의 이름은 \(menuName)인 메뉴에 대해서 인스타그램 피드를 작성해줘. \(pointText)"
    }
    
    // MARK: - Caption 생성
    func createCaption() async{
        viewModel.prompt = self.currentInput
        self.currentInput = ""
        let response = await chatGptService.sendMessage(messages: self.messages)
        viewModel.promptAnswer = response?.choices.first?.message.content == nil ? "" : response!.choices.first!.message.content
        viewModel.category = "메뉴"
        
        print(response as Any)
    }
}
