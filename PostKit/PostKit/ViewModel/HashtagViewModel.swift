//
//  HashTagViewModel.swift
//  PostKit
//
//  Created by doeun kim on 10/31/23.
//

import Foundation

// MARK: - Hashtag Keyword와 생성된 Hashtag 관리
final class HashtagViewModel: ObservableObject {
    static let shared = HashtagViewModel()
    
    @Published var id : UUID
    @Published var locationKey : Array<String>
    @Published var emphasizeKey : Array<String>
    @Published var hashtag : String
    
    init(id : UUID = UUID(), locationKey : Array<String> = [], emphasizeKey : Array<String> = [], hashtag : String = ""){
        self.id = id
        self.locationKey = locationKey
        self.emphasizeKey = emphasizeKey
        self.hashtag = hashtag
    }
}
