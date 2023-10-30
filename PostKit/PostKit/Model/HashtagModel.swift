//
//  HashtagModel.swift
//  PostKit
//
//  Created by Kim Andrew on 10/30/23.
//

import Foundation

class HashtagModel: Identifiable {
    @Published var id: UUID = UUID()
    @Published var date : Date
    @Published var localName : [String]
    @Published var keyword : [String]
    @Published var hashtag : String
    
    init(_id: UUID, _date: Date, _localName: [String], _keyword: [String], _hashtag: String) {
        self.id = _id
        self.date = _date
        self.localName = _localName
        self.keyword = _keyword
        self.hashtag = _hashtag
    }
}
