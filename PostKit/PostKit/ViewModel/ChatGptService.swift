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
        return Constants.ChatGptAPIKey
    }
    
    func sendMessage(messages: [Message]) async -> chatGptResponse? {
        let openAIMessages = messages.map({chatGptMessage(role: .user, content: $0.content)})
        let randomKey = getRandomKey()
        let body = chatGptBody(model: "gpt-4-0613", messages: openAIMessages)
        let headers: HTTPHeaders =  [
            "Authorization" : "Bearer \(randomKey)"
        ]
        
        return try? await AF.request(baseUrl, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(chatGptResponse.self).value
    }
}
