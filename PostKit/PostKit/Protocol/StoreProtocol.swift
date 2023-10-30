//
//  StoreProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/12/23.
//

import Foundation

protocol StoreProtocol {
    
    /// onBoarding View -> CoreData로 정보를 저장합니다.
    /// - Parameters:
    ///   - storeName: (옵셔널) 가게 이름
    ///   - tone: 선택한 글 톤
    func saveStoreData(storeName: String, storeTone: Array<String>)
    
    /// CoreData에서 필요한 경우 가계의 정보를 불러옵니다.
    /// - Parameters:
    ///   - storeName: 가게 이름
    ///   - tone: 선택한 글 톤
    func fetchStoreData()
    
    /// 가게 정보를 초기화합니다.
    func deletStoreData()
}
