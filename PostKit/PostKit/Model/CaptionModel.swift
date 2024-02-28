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

//MARK: 이미지 리소스 필요
public var CaptionCtgModel: [(imageName: String, name: String, destination: categoryType, path: StackViewType)] = [
    ("visionpro", "일상", categoryType.cafe, StackViewType.Daily),
    ("visionpro", "메뉴", categoryType.cafe, StackViewType.Menu),
    ("visionpro", "상품", categoryType.fassion, StackViewType.Goods)
]
