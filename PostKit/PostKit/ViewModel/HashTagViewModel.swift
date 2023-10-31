//
//  HashTagViewModel.swift
//  PostKit
//
//  Created by doeun kim on 10/31/23.
//

import Foundation

// MARK: - HashTag Keyword와 생성된 HashTag 관리
final class HashTagViewModel: ObservableObject {
    static let shared = HashTagViewModel()
    
    @Published var locationKey : Array<String>
    @Published var emphasizeKey : Array<String>
    @Published var hashTag : String
    
    init(locationKey : Array<String> = [], emphasizeKey : Array<String> = [], hashTag : String = ""){
        self.locationKey = locationKey
        self.emphasizeKey = emphasizeKey
        self.hashTag = hashTag
    }
}
