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
    
    @Published var prompt : String
    @Published var promptAnswer :String
    
    init(prompt: String = "", promptAnswer: String = "생성된 텍스트가 들어가요.") {
        self.prompt = prompt
        self.promptAnswer = promptAnswer
    }
}
