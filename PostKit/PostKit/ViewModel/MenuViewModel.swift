//
//  MenuViewModel.swift
//  PostKit
//
//  Created by doeun kim on 11/1/23.
//

import Foundation

extension MenuView {
    // MARK: - Chat Gpt API에 응답 요청
    func sendMessage(coffeeSelected: Array<String>, dessertSelected: Array<String>, drinkSelected: Array<String>, menuName: String){
        Task{
            createPrompt(coffeeSelected: coffeeSelected, dessertSelected: dessertSelected, drinkSelected: drinkSelected, menuName: menuName)
            self.messages.append(Message(id: UUID(), role: .user, content: self.currentInput))
            createCaption()
        }
    }
    
    // MARK: - Prompt 생성
    func createPrompt(coffeeSelected: Array<String>, dessertSelected: Array<String>, drinkSelected: Array<String>, menuName: String){
        var pointText = ""
        var toneInfo = ""
        var basicPrompt = ""
        
        for _tone in storeModel.tone {
            if _tone == "" {
                break
            }
            
            toneInfo += _tone + ","
        }
        
        if toneInfo == "" {
            toneInfo = "평범"
        }
        
        basicPrompt = "너는 \(storeModel.storeName)를 운영하고 있으며 \(toneInfo)한 말투를 가지고 있어. 글은 존댓말로 작성해줘. 다른 부연 설명은 하지 말고 응답 내용만 작성해줘. 글자수는 꼭 \(textLength)자 정도로 작성해줘."
        self.messages.append(Message(id: UUID(), role: .system, content: basicPrompt))
        print(basicPrompt)
        viewModel.basicPrompt = basicPrompt
        
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
    func createCaption() {
        viewModel.prompt = self.currentInput
        self.currentInput = ""
        chatGptService.sendMessage(messages: self.messages)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        // TODO: - 오류 코드를 기반으로 오류 처리 진행 필요
                        print("error 발생. error code: \(error._code)")
                    case .finished:
                        print("Caption 생성이 무사히 완료되었습니다.")
                    }
                },
                receiveValue:  { response in
                    print("response: \(response)")
                    guard let textResponse = response.choices.first?.message.content else {return}
                    
                    viewModel.promptAnswer = textResponse
                    viewModel.category = "메뉴"
                }
            )
            .store(in: &cancellables)
    }
}
