//
//  CaptionModel.swift
//  PostKit
//
//  Created by Kim Andrew on 10/30/23.
//

import Foundation

class CaptionModel : ObservableObject {
    @Published var id : UUID
    @Published var date : Date
    @Published var category : String
    @Published var caption : String
    
    init(_id: UUID, _date: Date, _category: String, _caption: String) {
        self.id = _id
        self.date = _date
        self.category = _category
        self.caption = _caption
    }
}
