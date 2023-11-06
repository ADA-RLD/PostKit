//
//  DesginSystem.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import SwiftUI


enum Pretendard {
    case black
    case bold
    case extraBold
    case extraLight
    case light
    case medium
    case regular
    case semiBold
    case thin
    
    var value: String {
        switch self {
        case .black:
            return "Pretendard-Black"
        case .bold:
            return "Pretendard-Bold"
        case .extraBold:
            return "Pretendard-ExtraBold"
        case .extraLight:
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

extension Font {
    // MARK: Typograpy
    // linespacing 4
    static func title1() -> Font {
        return .custom(Pretendard.bold.value, size: 24)
    }
    // linesapcing 4
    static func title2() -> Font {
        return .custom(Pretendard.bold.value, size: 20)
    }
    // size 16 == linespacing 4
    static func body1Bold() -> Font {
        return .custom(Pretendard.semiBold.value, size: 16)
    }
    // MARK: linesapcing 4
    static func body1Regular() -> Font {
        return .custom(Pretendard.regular.value, size: 16)
    }
    // MARK: 13 == linsapcing 2
    static func body2Bold() -> Font {
        return .custom(Pretendard.semiBold.value, size: 13)
    }
    
    static func body2Regular() -> Font {
        return .custom(Pretendard.regular.value, size: 13)
    }
}

extension Text {
    
    func title1(textColor: Color) -> some View {
        return self.font(.title1())
            .foregroundColor(textColor)
            .lineSpacing(4)
    }
    
    func title2(textColor: Color) -> some View {
        return self.font(.custom(Pretendard.bold.value, size: 20))
            .foregroundColor(textColor)
            .lineSpacing(4)
    }
    
    func body1Bold(textColor: Color) -> some View {
        return self.font(.custom(Pretendard.semiBold.value, size: 16))
            .foregroundColor(textColor)
            .lineSpacing(4)
    }
    
    func body1Regular(textColor: Color) -> some View {
        return self.font(.custom(Pretendard.regular.value, size: 16))
            .foregroundColor(textColor)
            .lineSpacing(4)
    }
    
    func body2Bold(textColor: Color) -> some View {
        return self.font(.custom(Pretendard.semiBold.value, size: 13))
            .foregroundColor(textColor)
            .lineSpacing(2)
    }
    
    func body2Regular(textColor: Color) -> some View {
        return self.font(.custom(Pretendard.regular.value, size: 13))
            .foregroundColor(textColor)
            .lineSpacing(2)
    }
}
// MARK: 패딩 값 모음
public let paddingHorizontal: CGFloat = 20
public let paddingTop: CGFloat = 20
public let paddingBottom: CGFloat = 80

// MARK: 곡률 값 모음
public let radius1: CGFloat = 16
public let radius2: CGFloat = 12
