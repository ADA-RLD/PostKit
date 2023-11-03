//
//  SettingProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/17/23.
//

import Foundation

protocol SettingProtocol {
    
    /// 가게 정보를 CoreData에서 가져옵니다.
    func fetchStoreData()
    
    /// 변경된 가게 정보를 CoreData에 저장합니다.
    /// - Parameters:
    ///   - storeName: 가게 이름
    ///   - storeTone: 변경된 톤 Array
    func saveStoreData(storeName: String, storeTone: Array<String>)
    
}
