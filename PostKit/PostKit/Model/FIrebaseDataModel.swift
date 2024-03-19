//
//  FIrebaseDataModel.swift
//  PostKit
//
//  Created by 김다빈 on 3/19/24.
//

import Foundation
import FirebaseFirestoreSwift


public enum captionType: String, CaseIterable {
    case onlyKeywords = "OnlyKeywords"
    case onlyImage = "OnlyImage"
    case both = "Both"
    
    var type: String {
        switch self {
        case .onlyImage:
            return "OnlyImage"
        case .onlyKeywords:
            return "OnlyKeywords"
        case .both:
            return "Both"
        }
    }
}

struct ImageInfo {
    var captionResult: String
    
    var data: [String: Any] {
        return [
            "CaptionResult": captionResult
        ]
    }
}

struct CpationInfo {
    var customKeywords: [String]?
    var recommendKeywords: [String]?
    var captionResult: String
    var isIncludeImage: Bool
    
    var data: [String: Any] {
        return [
            "CustomKeywords": customKeywords?.joined(separator: ", ") ?? "",
            "RecommendKeywords": recommendKeywords?.joined(separator: ",") ?? "",
            "CaptionResult": captionResult
        ]
    }
}
