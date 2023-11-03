//
//  MainViewProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/13/23.
//

import Foundation
import CoreData

protocol MainViewProtocol {
    
    /// CoreData에서 가게 정보를 가져옵니다.
    func fetchStoreData()
    
    /// CoreData에서 피드글 정보를 가져옵니다.
    func fetchCaptionData()
    
    /// CoreData에서 해시태그 정보를 가져옵니다.
    func fetchHashtagData()
    
    /// 좋아요가 변화하면 피드글 정보를 업데이트 합니다.
    /// - Parameters:
    ///   - _uuid: 선택한 글의 고유 ID
    ///   - _result: 수정된 글 정보
    ///   - _like: 수정된 좋아요 상태
    func saveCaptionData(_uuid: UUID, _result: String, _like: Bool)
    
    /// 좋아요가 변화하면 해시태그 정보를 업데이트 합니다.
    /// - Parameters:
    ///   - _uuid: 선택한 해시태그 고유 ID
    ///   - _result: 수정된 해시태그 정보
    ///   - _like: 수정된 좋아요 상태
    func saveHashtageData(_uuid: UUID, _result: String, _like: Bool)
    
    /// 선택한 피드글을 CoreData에서 영구삭제합니다.
    /// 삭제된 글은 저장되지 않습니다. 사용에 유의하세요
    /// - Parameter _uuid: 선택한 피드글 고유ID
    func deleteCaptionData(_uuid: UUID)
    
    /// 선택한 해시태그를 CoreData에서 영구삭제합니다.
    /// 삭제된 글은 저장되지 않습니다. 사용에 유의하세요.
    /// - Parameter _uuid: 선택한 해시태그 고유ID
    func deleteHashtagData(_uuid: UUID)
    
    /// 날짜 형식을 yyyy.MM.dd 형태로 변환 합니다.
    /// - Parameter date: Date() 데이터
    /// - Returns: yyyy.MM.dd 형태 문자열
    func convertDate(date: Date) -> String
    
}
