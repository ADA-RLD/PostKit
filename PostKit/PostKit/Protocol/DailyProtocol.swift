//
//  DailyProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/12/23.
//

import Foundation

protocol DailyProtocol {
    
    /// 날짜에 따른 스트립션을 저장합니다.
    /// - Parameters:
    ///   - recordId: 데이터 고유 ID
    ///   - recordDate: 저장 날짜
    ///   - storeName: 가게 이름
    ///   - Tone: 설정 톤
    ///   - weather: 날씨 정보
    ///   - dessert: 설명할 디저트 정보
    ///   - drink: 설명할 음료 정보
    func saveDailyData(recordId: UUID, recordDate: Date?, storeName: String?, Tone: String, weather: String?, dessert: String?, drink: String?)
    
    /// 뷰에서 필요하다면 저장된 음료, 디저트의 정보를 가져옵니다.
    /// - Parameter dessert: 디저트 정보
    /// - Parameter drink: 음료 정보
    func fetchDailyData(dessert: String, drink: String)
    
    /// 저장된 디저트 혹은 음료의 정보를 삭제합니다
    /// - Parameter dessert: 디저트 정보
    /// - Parameter drink: 음료 정보
    func deletDailyData(dessert: String, drink: String)
}
