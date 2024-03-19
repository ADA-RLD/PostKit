//
//  FIrebaseDataModel.swift
//  PostKit
//
//  Created by 김다빈 on 3/19/24.
//

import Foundation
import FirebaseFirestoreSwift

struct KeywordCaptionInfo {
    var customKeywords: [String]?
    var recommendKeywords: [String]?
    var captionResult: String
}

struct CpationInfo {
    var customKeywords: [String]?
    var recommendKeywords: [String]?
    var captionResult: String
    var isIncludeImage: Bool
}
