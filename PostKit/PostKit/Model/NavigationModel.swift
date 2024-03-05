//
//  NavigationModel.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import Foundation


public enum StackViewType {
    case Menu
    case Daily
    case Goods
    case Fashion
    case Hair
    case SettingHome
    case SettingStore
    case SettingTone
    case SettingCS
    case Loading
    case CaptionResult
    case HashtagResult
    case ErrorNetwork
    case ErrorResultFailed
    case Hashtag
}

class PathManager: ObservableObject {
    @Published var path: [StackViewType] = []
}
