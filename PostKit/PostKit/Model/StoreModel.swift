//
//  StoreModel.swift
//  PostKit
//
//  Created by Kim Andrew on 10/12/23.
//

import Foundation

 class StoreModel : ObservableObject {
     @Published var storeName : String?
     @Published var tone : String

     init(_storeName: String? = nil, _tone: String) {
         self.storeName = _storeName
         self.tone = _tone
     }
 }
