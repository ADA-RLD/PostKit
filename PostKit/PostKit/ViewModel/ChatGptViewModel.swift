//
//  ChatGptViewModel.swift
//  PostKit
//
//  Created by doeun kim on 10/13/23.
//

import Foundation

// MARK: - ChatGpt prompt와 prompt답변 관리
final class ChatGptViewModel: ObservableObject {
    static let shared = ChatGptViewModel()
    
    @Published var category : String
    @Published var basicPrompt : String
    @Published var prompt : String
    @Published var promptAnswer : String
    @Published var imageURL: String
    @Published var customKeywords: [String]
    @Published var recommendKeywords: [String]
    
    init(category: String = "", basicPrompt: String = "", prompt: String = "", promptAnswer: String = "생성된 텍스트가 들어가요.", imageURL:String = "", customKeyword:[String] = [], recommendKeywords:[String] = []) {
        
        self.customKeywords = customKeyword
        self.recommendKeywords = recommendKeywords
        self.category = category
        self.basicPrompt = basicPrompt
        self.prompt = prompt
        self.promptAnswer = promptAnswer
        self.imageURL = imageURL

    }
}
