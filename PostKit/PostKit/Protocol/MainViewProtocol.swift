//
//  MainViewProtocol.swift
//  PostKit
//
//  Created by Kim Andrew on 10/13/23.
//

import Foundation

protocol MainViewProtocol {
    
    func resetData()
    
    func fetchStoreData()
    
    func fetchCaptionData()
    
    func fetchHashtagData()
    
    func convertDate(date: Date) -> String
}
