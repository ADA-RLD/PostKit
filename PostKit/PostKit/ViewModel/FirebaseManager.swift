//
//  FirebaseManager.swift
//  PostKit
//
//  Created by 김다빈 on 11/14/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import Combine
import FirebaseFirestoreSwift


class FirebaseManager {
    private let db = Firestore.firestore()
    
    func getDoucument(apiName: String, completion: @escaping (String) -> Void) {
        let keyDocs = db.collection("PostKit").document("APIKeys")

        
        keyDocs.getDocument { (document, error) in
            if let document = document, document.exists {
                let APIKey = document[apiName] as? String ?? "nil"
                completion(APIKey)
            } else {
                print("Document Error")
            }
        }
    }
    
    func updateCaptionResult(cpationType: captionType, Data: Dictionary<String, Any>) {
        let postDocs = db.collection("CaptionResult").document("Type").collection(cpationType.type).document()
        postDocs.setData(Data)
    }
    
    func getKeyWordsDocument(keyWordType: String, keyWordName: String, completion: @escaping ([String]) -> Void) {
        let keyWordDocs = db.collection("PostKit").document(keyWordType)
        
        keyWordDocs.getDocument { (document, error) in
            if let document = document, document.exists {
                let keyWords = document[keyWordName] as? [String] ?? []
                completion(keyWords)
            } else {
                print("Document Error")
            }
        }
    }
}
