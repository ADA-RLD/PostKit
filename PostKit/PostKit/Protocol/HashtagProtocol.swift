//
//  HashtagProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/30/23.
//

import Foundation

/// 해쉬태그를 코어데이터에 저장하고 가져옵니다.
protocol HashtagProtocol {
    func convertDayTime(time: Date) -> Date 
        
    func FetchHashtag()
    
    func SaveHashtag(date: Date, locationTag: Array<String>, keyword: Array<String>, Result: String)
    
}
