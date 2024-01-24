//
//  NavigationModel.swift
//  PostKit
//
//  Created by 김다빈 on 10/11/23.
//

import Foundation


enum StackViewType {
    case Menu
    case Daily
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
    case Goods
}

class PathManager: ObservableObject {
    @Published var path: [StackViewType] = []
}
