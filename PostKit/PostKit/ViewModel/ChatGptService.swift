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
    
    func getRandomKey() -> String {
        let randomIndex = Int.random(in: 0..<Constants.ChatGptAPIKey.count)
        return Constants.ChatGptAPIKey[randomIndex]
    }
    
    func sendMessage(messages: [Message]) async -> chatGptResponse? {
        let openAIMessages = messages.map({chatGptMessage(role: .system, content: $0.content)})
        let randomKey = getRandomKey()
        print(randomKey)
        let body = chatGptBody(model: "gpt-3.5-turbo-0301", messages: openAIMessages)
        let headers: HTTPHeaders =  [
            "Authorization" : "Bearer \(randomKey)"
        ]
        
        return try? await AF.request(baseUrl, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(chatGptResponse.self).value
    }
}
