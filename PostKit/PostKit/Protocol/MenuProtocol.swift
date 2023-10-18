//
//  MenuProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/12/23.
//

import Foundation

protocol MenuProtocol {
    
    /// 설정된 메뉴 스트립션을 저장합니다.
    /// - Parameters:
    ///   - recordId: 데이터 고유 ID
    ///   - recordDate: 저장 날짜
    ///   - storeName: 가게 이름
    ///   - tone: 가게가 설정한 톤
    ///   - menuName: 설정 메뉴
    ///   - menuPoint: 메뉴 강점
    func saveMenuData(recordId: UUID, recordDate: Date?, menuName: String, menuPoint: String)
    
    /// 뷰에서 필요하다면 저장된 메뉴와 강점을 Fetch할 수 있습니다
    /// - Parameters:
    ///   - menuName: 메뉴 이름
    ///   - menuPoint: 이전에 저장된 메뉴 강점
    func fetchMenuData(menuName: String, menuPoint: String)
    
    /// 저장된 메뉴와 강점을 삭제 합니다.
    func deletStoreData(menuName: String, menuPoint: String)
}
