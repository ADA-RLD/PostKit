//
//  MainViewProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/13/23.
//

import Foundation

protocol MainViewProtocol {
    
    func fetchStoreData()
    
    func fetchCaptionData()
    
    func fetchHashtagData()
    
    func saveCaptionData(_uuid: UUID, _result: String, _like: Bool)
    
    func saveHashtageData(_uuid: UUID, _result: String)
    
    func convertDate(date: Date) -> String
}
