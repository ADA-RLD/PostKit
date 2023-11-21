//
//  FirebaseManager.swift
//  PostKit
//
//  Created by 김다빈 on 11/14/23.
//

import Foundation
import Firebase

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
}
