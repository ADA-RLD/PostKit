//
//  DesginSystem.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI


//MARK: Font
extension Font {
    enum Pretendard {
        case black
        case bold
        case extrabold
        case extralight
        case light
        case medium
        case regular
        case semiBold
        case thin
        
        var value: String {
            switch self {
            case.black:
                return "Pretendard-Black"
            case .bold:
                return "Pretendard-Bold"
            case .extrabold:
                return "Pretendard-ExtraBold"
            case .extralight:
                return "Pretendard-ExtraLight"
            case .light:
                return "Pretendard-Light"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .thin:
                return "Pretendard-Thin"
            }
        }
    }
    
    // MARK: Typograpy
    static func title1() -> Font {
        return .custom(Pretendard.bold.value, size: 24)
    }

    static func title2() -> Font {
        return .custom(Pretendard.bold.value, size: 20)
    }
    
    static func body1Bold() -> Font {
        return .custom(Pretendard.semiBold.value, size: 16)
    }
    
    static func body1Regular() -> Font {
        return .custom(Pretendard.regular.value, size: 16)
    }
    
    static func body2Bold() -> Font {
        return .custom(Pretendard.semiBold.value, size: 13)
    }
    
    static func body2Regular() -> Font {
        return .custom(Pretendard.regular.value, size: 13)
    }
}



// MARK: 패딩 값 모음
public let paddingHorizontal: CGFloat = 20
public let paddingTop: CGFloat = 20
public let paddingBottom: CGFloat = 80

// MARK: 곡률 값 모음
public let radius1: CGFloat = 16
public let radius2: CGFloat = 12



