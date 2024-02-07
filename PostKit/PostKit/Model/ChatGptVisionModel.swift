//
//  ChatGptVisionModel.swift
//  PostKit
//
//  Created by 김다빈 on 2/7/24.
//

import Foundation


struct ChatGptVisionBody: Encodable {
    let model: String
    let messages: [GptVisionMessage]
}

struct GptVisionMessage: Codable {
    let role: SenderRole
    let content: [GptVisionContent]
}

struct GptVisionContent: Codable {
    let type: String
    let text: String?
    let image_url: ImageURL?
}

struct ImageURL: Codable {
    let url: String
}

struct ChatGptVisionResponse: Decodable {
    let choices: [ChatGptVisionChoice]
}

struct ChatGptVisionChoice: Decodable {
    let finish_reason: String
    let message: GptVisionMessage
}
