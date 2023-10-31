//
//  HashtagPopover.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/31.
//

import SwiftUI

enum PopOverType {
    case region
    case keyword
    
    var description : [String] {
      switch self {
      case .region: return [
        "시 단위의 큰 지역",
        "ex) 서울, 부산, 제주...",
        "동 단위의 작은 지역",
        "ex) 성수동, 한남동, 망원동...",
        "지역의 랜드마크",
        "ex) 남산타워, 한강, 서울숲..."
      ]
      case .keyword: return [
        "카페의 대표 메뉴",
        "ex) 휘낭시에, 딸기케이크, 소금커피, 푸딩",
        "카페의 특징",
        "ex) 애견동반, 브런치맛집, 대형카페, 노키즈존"
      ]
      }
    }
}

struct TriangleView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}
