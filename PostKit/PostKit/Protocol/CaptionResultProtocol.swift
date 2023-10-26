//
//  CaptionResultProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/26/23.
//

import Foundation

protocol CaptionResultProtocol {
    
    func saveCaptionResult(Id: UUID, date: Date,category: String, Result: String)
    
    func fetchCaptionResult(category: String)
}
