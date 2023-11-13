//
//  ChatGptService.swift
//  PostKit
//
//  Created by doeun kim on 10/12/23.
//

import Foundation
import Alamofire
import Combine

class ChatGptService {
    private let baseUrl = "https://api.openai.com/v1/chat/completions"
    // 키 오류를 대비해서 랜덤하게 키를 게속 바꿔줍니다.
    func getRandomKey() -> String {
        let randomIndex = Int.random(in: 0..<Constants.ChatGptAPIKey.count)
        return Constants.ChatGptAPIKey[randomIndex]
    }
    
    func sendMessage(messages: [Message]) -> AnyPublisher<chatGptResponse, Error> {
        let openAIMessages = messages.map({chatGptMessage(role: .user, content: $0.content)})
        let randomKey = getRandomKey()
        // TODO: - 개발을 진행하는 동안 3.5로 진행하고 이후 배포시 4.0으로 상향 조정할 예정
        let body = chatGptBody(model: "gpt-4-1106-preview", messages: openAIMessages)
        let headers: HTTPHeaders =  [
            "Authorization" : "Bearer \(randomKey)"
        ]
        
        return Future <chatGptResponse, Error>{ promise in
            AF.request(self.baseUrl, method: .post, parameters: body, encoder: .json, headers: headers)
                .responseDecodable(of: chatGptResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        print("success: \(result)")
                        promise(.success(result))
                    case .failure(let error):
                        print("error 상세 내용: \(error)")
                        print("error_code: \(error._code)")
                        // error code 별 오류
                        // 10: keyNotFound - choices string not found: nil 값 error
                        // 13: InternetNotFound - offline인 상태로 인해 error 발생
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
