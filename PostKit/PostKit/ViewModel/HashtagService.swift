//
//  HashtagService.swift
//  PostKit
//
//  Created by doeun kim on 10/31/23.
//

import Foundation

class HashtagService {
    func createHashtag(locationArr: Array<String>, emphasizeArr: Array<String>) -> String{
        // 생성할 최대 해시태그 수
        let maxCnt = 15
        // 방문한 수
        var visitCnt = 0
        
        let topBasicArr: Array<String> = ["카페", "카페추천", "카페투어"]
        let bottomBasicArr: Array<String> = ["카페맛집", "카페그램", "카페탐방", "카페스타그램", "신상카페", "데이트", "핫플", "핫플레이스", "커피맛집", "분위기좋은카페", "감성카페", "카페거리"]
        var resultArr: Array<String> = []
        var locationVisitArr = Array(repeating: 0, count: locationArr.count)
        var basicVisitArr = Array(repeating: 0, count: maxCnt)
        
        // 강조 키워드 전부 사용
        for (index, value) in emphasizeArr.enumerated() {
            print((index, value))
            var idx = Int.random(in: 0...locationArr.count - 1)
            
            while true {
                // 이미 사용된 키워드일 경우, 아직 사용되지 않은 다음 키워드를 확인
                if locationVisitArr[idx] == 1 {
                    idx+=1
                    if idx >= locationArr.count {
                        idx %= locationArr.count
                    }
                }
                else{
                    break
                }
            }
            
            locationVisitArr[idx] = 1
            visitCnt+=1
            
            // 모두 방문했을 경우, visit 배열 초기화
            if visitCnt == locationArr.count {
                visitCnt = 0
                for i in 0...locationArr.count - 1 {
                    locationVisitArr[i] = 0
                }
            }
            
            resultArr.append(emphasizeArr[index] + locationArr[idx])
        }
        
        // 일반 키워드 사용 location + basic
        for _ in 1...(maxCnt-emphasizeArr.count){
            // 0~5 나올 시 top basic, 나머지는 bottom
            // top에 가중치 2 부여, bottom은 가중치 1 부여
            var locationIdx = Int.random(in: 0...locationArr.count - 1)
            var basicIdx = Int.random(in: 0...maxCnt+topBasicArr.count - 1)
            
            var basicKey = ""
            
            // 상위 키워드에 해당하는 인덱스인지 하위 키워드에 해당하는 인덱스인지 확인
            if basicIdx <= topBasicArr.count*2-1 {
                basicIdx %= topBasicArr.count
            }
            else {
                basicIdx -= topBasicArr.count*2
            }
            
            // 방문한 locationIndex일 경우, locationIndex 변경
            while true {
                // 이미 사용된 키워드일 경우, 아직 사용되지 않은 다음 키워드를 확인
                if locationVisitArr[locationIdx] == 1 {
                    locationIdx+=1
                    if locationIdx >= locationArr.count {
                        locationIdx %= locationArr.count
                    }
                }
                else{
                    break
                }
            }
            
            // 방문한 basicIndex일 경우, basicIndex 변경
            while true {
                // 이미 사용된 키워드일 경우, 아직 사용되지 않은 다음 키워드를 확인
                if basicVisitArr[basicIdx] == 1 {
                    basicIdx+=1
                    if basicIdx >= maxCnt {
                        basicIdx %= maxCnt
                    }
                }
                else{
                    break
                }
            }
            
            // top basic 매칭
            if basicIdx <= topBasicArr.count - 1 {
                basicKey = topBasicArr[basicIdx]
            }
            // bottom basic 매칭
            else {
                basicKey = bottomBasicArr[basicIdx - topBasicArr.count]
            }
            
            locationVisitArr[locationIdx] = 1
            basicVisitArr[basicIdx] = 1
            visitCnt+=1
            
            // 모두 방문했을 경우, visit 배열 초기화
            if visitCnt == locationArr.count {
                visitCnt = 0
                for i in 0...locationArr.count-1 {
                    locationVisitArr[i] = 0
                }
            }
            
            resultArr.append(locationArr[locationIdx] + basicKey)
        }
        
        var resultStr = ""
        
        for id in 0...maxCnt-1 {
            resultStr += "#" + resultArr[id] + " "
        }
                
        return resultStr
    }
}

