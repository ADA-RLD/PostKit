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
    case goods
    case fassion
    case hair
    case brwoshop
}

//MARK: 이미지 리소스 필요
public var CaptionCtgModel: [(imageName: String, name: String, destination: categoryType, path: StackViewType)] = [
    ("Cafe", "일상", categoryType.cafe, .Daily),
    ("Goods", "상품", categoryType.goods, .Goods),
    ("Fashion", "패션", categoryType.fassion, .Fashion),
    ("Hair", "헤어", categoryType.hair, .Hair),
    ("BrowShop", "브로우샵", categoryType.brwoshop, .BrowShop)
]
