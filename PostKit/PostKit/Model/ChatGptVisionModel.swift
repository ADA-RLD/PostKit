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
    let content: Contents
}

enum Contents: Codable {
    case string(String)
    case array([GptVisionContent])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let array = try? container.decode([GptVisionContent].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "content data is not")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string):
            try container.encode(string)
        case .array(let array):
            try container.encode(array)
        }
    }
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
