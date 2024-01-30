//
//  ChatGptModel.swift
//  PostKit
//
//  Created by doeun kim on 10/12/23.
//

import Foundation

struct chatGptBody: Encodable {
    let model: String
    let messages: [chatGptMessage]
}

struct chatGptMessage: Codable {
    let role: SenderRole
    let content: Content
}

struct Content: Codable {
    let type: String
    let text: String?
    let imageUrl: ImageURL?
}

struct ImageURL: Codable {
    let url: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct chatGptResponse: Decodable {
    let choices: [chatGptChoice]
}

struct chatGptChoice: Decodable {
    let finish_reason: String
    let message: chatGptMessage
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
}
