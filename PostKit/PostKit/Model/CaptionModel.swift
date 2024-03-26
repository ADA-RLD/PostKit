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

public enum captionLength: Int, CaseIterable {
    case short
    case middle
    case long
    
    var korcaptionLength: String {
        switch self {
        case .short:
            return "짧음"
        case .middle:
            return "중간"
        case .long:
            return "긺"
        }
    }
    
    var captionLength: Int {
        switch self {
        case .short:
            return 100
        case .middle:
            return 200
        case .long:
            return 300
        }
    }
}

public enum categoryType: String, CaseIterable{
    case cafe
    case fashion
    case hair
    case browShop
    
    var korCategoryName: String {
        switch self {
        case .cafe:
            return "카페"
        case .fashion:
            return "패션"
        case .hair:
            return "헤어"
        case .browShop:
            return "브로우샵"
        }
    }
    
    var placeholderName: String {
        switch self {
        case .cafe:
            return "아메리카노"
        case .fashion:
            return "발마칸 코트"
        case .hair:
            return "히피펌"
        case .browShop:
            return "속눈썹 연장"
        }
    }
    
    var picekrList: [String] {
        switch self {
            
        case .cafe:
            return ["음료", "디저트", "일상"]
        case .fashion:
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
    ("Fashion", "패션", categoryType.fashion, .Fashion),
    ("Hair", "헤어", categoryType.hair, .Hair),
    ("Brow", "브로우샵", categoryType.browShop, .BrowShop)
]
