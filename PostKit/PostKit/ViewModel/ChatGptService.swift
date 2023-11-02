//
//  ChatGptService.swift
//  PostKit
//
//  Created by doeun kim on 10/12/23.
//

import Foundation
import Alamofire

class ChatGptService {
    private let baseUrl = "https://api.openai.com/v1/chat/completions"
    // 키 오류를 대비해서 랜덤하게 키를 게속 바꿔줍니다.
    func getRandomKey() -> String {
        let randomIndex = Int.random(in: 0..<Constants.ChatGptAPIKey.count)
        return Constants.ChatGptAPIKey[randomIndex]
    }
    
    func sendMessage(messages: [Message]) async -> chatGptResponse? {
        let openAIMessages = messages.map({chatGptMessage(role: .user, content: $0.content)})
        let randomKey = getRandomKey()
        // TODO : - 개발을 진행하는 동안 3.5로 진행하고 이후 배포시 4.0으로 상향 조정할 예정
        let body = chatGptBody(model: "gpt-3.5-turbo", messages: openAIMessages)
        let headers: HTTPHeaders =  [
            "Authorization" : "Bearer \(randomKey)"
        ]
        
        do {
            // TODO : - Configuration을 설정하여 timeout 별도로 설정할 예정
            let response = try? await AF.request(baseUrl, method: .post, parameters: body, encoder: .json, headers: headers)
                .serializingDecodable(chatGptResponse.self)
                .value
            
            print("response: ")
            print(response as Any)
            
            if response == nil {
                throw ResponseError.noResponse
            }
            
            return response
        } 
        catch {
            print("error: \(error)")
            // MARK: - Chat Gpt 에러 처리
            if error._code == NSURLErrorTimedOut {
                print("Time Out Error 발생")
                return chatGptResponse(choices: [chatGptChoice(finish_reason: "", message: chatGptMessage(role: .system, content: "TIMEOUT"))])
            }
            else if error as! ResponseError == ResponseError.noResponse {
                print("Nil Response Error 발생")
                return chatGptResponse(choices: [chatGptChoice(finish_reason: "", message: chatGptMessage(role: .system, content: "NILError"))])
            }
            else {
                print("error: \(error) Server Error 발생")
                return chatGptResponse(choices: [chatGptChoice(finish_reason: "", message: chatGptMessage(role: .system, content: "ServerError"))])
            }
        }
    }
}
