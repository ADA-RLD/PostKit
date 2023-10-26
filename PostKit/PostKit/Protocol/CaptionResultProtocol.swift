//
//  CaptionResultProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/26/23.
//

import Foundation

protocol CaptionResultProtocol {
    func convertDayTime(time: Date) -> Date
    
    func saveCaptionResult(category: String, date: Date ,Result: String)
    
    func fetchCaptionResult(category: String)
}
