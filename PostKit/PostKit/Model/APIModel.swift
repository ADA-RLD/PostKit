//
//  APIModel.swift
//  PostKit
//
//  Created by 김다빈 on 2/24/24.
//

import Foundation

struct APIResponse: Decodable {
    let captionResult: String
    let message: String
}

struct APIBody: Encodable {
    let prompt: String
}