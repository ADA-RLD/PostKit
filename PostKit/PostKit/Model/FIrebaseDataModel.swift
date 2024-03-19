//
//  FIrebaseDataModel.swift
//  PostKit
//
//  Created by 김다빈 on 3/19/24.
//

import Foundation
import FirebaseFirestoreSwift


public enum captionType: String, CaseIterable {
    case keywordsOnly = "OnlyKeywords"
    case imageOnly = "OnlyImage"
    case both = "Both"
    
    var type: String {
        switch self {
        case .imageOnly:
            return "OnlyImage"
        case .keywordsOnly:
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

struct CaptionInfo {
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
