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
}

class PathManager: ObservableObject {
    @Published var path: [StackViewType] = []
}
