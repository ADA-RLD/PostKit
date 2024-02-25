//
//  APIManager.swift
//  PostKit
//
//  Created by 김다빈 on 2/23/24.
//

import Foundation
import Alamofire
import Combine
import SwiftUI
import FirebaseFunctions

class APIManager: ObservableObject {
    static let shared = APIManager()
    
    @AppStorage("_isCanceled") var isCanceled: Bool = false
    @ObservedObject var coinManager = CoinManager.shared
    
    private let baseURL = "https://flaskexpose-7m5qznpftq-uc.a.run.app"
    
    func sendKeyWord(basicPrompt: String, prompt: String) -> AnyPublisher<APIResponse, Error> {
        return Future <APIResponse, Error> { promise in
            let body = APIBody(prompt: prompt, userInfo: basicPrompt)
            
            AF.request(self.baseURL + "/textCaption", method: .post, parameters: body, encoder: .json, headers: nil)
                .responseDecodable(of: APIResponse.self) { response in
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
                        print("생성실패")
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func sendImageKeyWord(basicPrompt: String, prompt: String, imageURL: String) -> AnyPublisher<APIResponse, Error> {
        return Future <APIResponse, Error> { promise in
            let body = ImageAPIBody(imageURL: imageURL, userInfo: basicPrompt, prompt: prompt)
            AF.request(self.baseURL + "/textImageCaption", method: .post, parameters: body, encoder: .json, headers: nil)
                .responseDecodable(of: APIResponse.self) { response in
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
        .eraseToAnyPublisher()
    }
}

