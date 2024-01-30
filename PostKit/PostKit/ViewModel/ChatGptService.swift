//
//  ChatGptService.swift
//  PostKit
//
//  Created by doeun kim on 10/12/23.
//

import Foundation
import Alamofire
import Combine
import SwiftUI

class ChatGptService: ObservableObject {
    static let shared = ChatGptService()
    
    @AppStorage("_isCanceled") var isCanceled: Bool = false
    @ObservedObject var coinManager = CoinManager.shared
    
    private let baseUrl = "https://api.openai.com/v1/chat/completions"
    private let firebaseManager = FirebaseManager()
    private var chatGptKey: String?
    // 키 오류를 대비해서 랜덤하게 키를 게속 바꿔줍니다.
    
    func getRandomKey(completion: @escaping () -> Void) {
        let chatGptAPIKey = firebaseManager.getDoucument(apiName: "chatgptAPI") { [weak self] (key) in
            self?.chatGptKey = key
            completion()
        }
    }
    
    func sendMessage(messages: [Message], imageUrl: String? = nil) -> AnyPublisher<chatGptResponse, Error> {
        return Future <chatGptResponse, Error> { promise in
            self.getRandomKey() {
                var openAIMessages = messages.map({ chatGptMessage(role: .user, content: Content(type: "text", text: $0.content, imageUrl: nil)) })
                
                if let imageUrl = imageUrl {
                    let visionMessage = chatGptMessage(role: .user, content: Content(type: "image_url", text: nil, imageUrl: ImageURL(url: imageUrl)))
                    openAIMessages.append(visionMessage)
                }
                
                let body = chatGptBody(model: "gpt-4-vision-preview", messages: openAIMessages)
                let headers: HTTPHeaders =  [
                    "Authorization" : "Bearer \(self.chatGptKey ?? "키 값 오류")"
                ]
                
                AF.request(self.baseUrl, method: .post, parameters: body, encoder: .json, headers: headers)
                    .responseDecodable(of: chatGptResponse.self) { response in
                        switch response.result {
                        case .success(let result):
                            print("success: \(result)")
                        if !self.isCanceled {
                            print("success: \(result)")
                            promise(.success(result))
                        }
                        else{
                            print("생성이 취소되었습니다.")
                            self.coinManager.coinCaptionUse()
                            self.isCanceled = false
                        }
                        case .failure(let error):
                            print("error 상세 내용: \(error)")
                            print("error_code: \(error._code)")
                            promise(.failure(error))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
