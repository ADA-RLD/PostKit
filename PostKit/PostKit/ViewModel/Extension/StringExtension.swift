//
//  StrExtension.swift
//  PostKit
//
//  Created by doeun kim on 11/7/23.
//

import Foundation

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
}
