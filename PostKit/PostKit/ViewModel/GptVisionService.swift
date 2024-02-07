//
//  GptVisionService.swift
//  PostKit
//
//  Created by 김다빈 on 2/7/24.
//

import Foundation
import Alamofire
import Combine
import SwiftUI

class GptVisionService: ObservableObject {
    static let shared = GptVisionService()
    
    @AppStorage("_isCanceled") var isCanceled: Bool = false
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = ChatGptViewModel.shared
    
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
    
    func sendMessage(messages: [GptVisionMessage]) -> AnyPublisher<ChatGptVisionResponse, Error> {
        return Future<ChatGptVisionResponse, Error> { promise in
            self.getRandomKey() {
                let minToken = 300
                let body = ChatGptVisionBody(model: "gpt-4-vision-preview", messages: messages)
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(self.chatGptKey ?? "키 값 오류")"
                ]

                
                AF.request(self.baseUrl, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers)
                    .responseDecodable(of: ChatGptVisionResponse.self) { response in
                        debugPrint(response)
                        switch response.result {
                        case .success(let result):
                            if !self.isCanceled {
                                promise(.success(result))
                            } else {
                                print("생성이 취소되었습니다.")
                                self.coinManager.coinCaptionUse()
                                self.isCanceled = false
                            }
                        case .failure(let error):
                            promise(.failure(error))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
