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

public enum categoryType: String, CaseIterable{
    case cafe
    case fassion
    case hair
    case browShop
    
    var korCategoryName: String {
        switch self {
        case .cafe:
            return "카페"
        case .fassion:
            return "패션"
        case .hair:
            return "헤어"
        case .browShop:
            return "브로우샵"
        }
    }
    
    var picekrList: [String] {
        switch self {
            
        case .cafe:
            return ["음료", "디저트", "일상"]
        case .fassion:
            return ["특징", "재질", "종류"]
        case .hair:
            return ["느낌", "스타일", "날씨"]
        case .browShop:
            return ["특징", "스타일", "일상"]
        }
    }
}

//MARK: 이미지 리소스 필요
public var CaptionCtgModel: [(imageName: String, name: String, destination: categoryType, path: StackViewType)] = [
    ("Cafe", "카페", categoryType.cafe, .Daily),
    ("Fashion", "패션", categoryType.fassion, .Fashion),
    ("Hair", "헤어", categoryType.hair, .Hair),
    ("Brow", "브로우샵", categoryType.browShop, .BrowShop)
]
