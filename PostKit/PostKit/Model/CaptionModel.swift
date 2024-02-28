//
//  CaptionModel.swift
//  PostKit
//
//  Created by Kim Andrew on 10/30/23.
//

import Foundation

class CaptionModel : Identifiable {
    @Published var id : UUID = UUID()
    @Published var date : Date
    @Published var category : String
    @Published var caption : String
    @Published var like : Bool
    
    init(_id: UUID, _date: Date, _category: String, _caption: String, _like: Bool) {
        self.id = _id
        self.date = _date
        self.category = _category
        self.caption = _caption
        self.like = _like
    }
}

public enum categoryType {
    case cafe
    case fassion
}

public var CaptionCtgModel: [(imageName: String, name: String, destination: categoryType)] = [("visionpro", "일상", categoryType.cafe), ("visionpro", "메뉴", categoryType.cafe), ("visionpro", "상품", categoryType.fassion)]
