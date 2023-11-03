//
//  HashtagProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/30/23.
//

import Foundation

/// 해쉬태그를 코어데이터에 저장하고 가져옵니다.
protocol HashtagProtocol {
    /// 사용자 지역에 맞게 Date 시간을 변경
    /// - Parameter time: 현재  위치 +00:00 시간
    /// - Returns: 현재 위치 지역의 시간
    func convertDayTime(time: Date) -> Date
    
    /// Description 해시태그 정보를 CoreData에서 가져옵니다.
    func fetchHashtag()
    
    /// 생성된 해시태그를 긴 문자열 형태로 저장합니다.
    /// - Parameters:
    ///   - date: 생성 날짜 Date()
    ///   - locationTag: 해시태그 생성에 필요한 위치 태그
    ///   - keyword: 해시태그 생성에 필요한 핵심 키워드
    ///   - result: 알고리즘에 의해 생성된 해시태그 결과
    ///   - isLike: 해시태그 좋아요 상태
    func saveHashtagResult(date: Date, locationTag: Array<String>, keyword: Array<String>, result: String, isLike: Bool) -> UUID
    
    /// 수정된 Hashtag 결과를 CoreData에 저장합니다,
    /// - Parameters:
    ///   - _uuid: 변경전의 해시태그 고유ID
    ///   - _result: 변경된 해시태그 문자열 정보
    ///   - _like: 변경된 좋아요 상태
    func saveEditHashtagResult(_uuid: UUID, _result: String, _like: Bool)
}
