//
//  CaptionResultProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/26/23.
//

import Foundation

protocol CaptionResultProtocol {
    /// 사용자 지역에 맞게 Date 시간을 변경
    /// - Parameter time: 현재  위치 +00:00 시간
    /// - Returns: 현재 위치 지역의 시간
    func convertDayTime(time: Date) -> Date
    
    /// Caption을 CoreData에 저장합니다.
    /// - Parameters:
    ///   - category: 카테고리 Daily 혹은 Menu 저장
    ///   - date: 생성된 날짜를 저장
    ///   - Result: 생셩된 결과 입력
    func saveCaptionResult(category: String, date: Date, result: String, like: Bool) -> UUID
    
    /// 변경된 피드글을 저장합니다.
    /// - Parameters:
    ///   - _uuid: 변경전의 피드글 고유ID
    ///   - _result: 변경된 피드글 정보
    ///   - _like: 변경된 좋아요 상태
    func saveEditCaptionResult(_uuid: UUID, _result: String, _like: Bool)
    
}
