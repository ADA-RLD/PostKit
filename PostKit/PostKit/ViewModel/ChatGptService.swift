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
    
    func sendMessage(messages: [Message]) async -> chatGptResponse? {
        let openAIMessages = messages.map({chatGptMessage(role: .system, content: $0.content)})
        
        let body = chatGptBody(model: "gpt-4", messages: openAIMessages)
        let headers: HTTPHeaders =  [
            "Authorization" : "Bearer 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"
        ]
        
        return try? await AF.request(baseUrl, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(chatGptResponse.self).value
    }
}
