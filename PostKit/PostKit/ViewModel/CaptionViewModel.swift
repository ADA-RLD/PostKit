//
//  CaptionViewModel.swift
//  PostKit
//
//  Created by 김다빈 on 3/23/24.
//

import Foundation
import CoreData
import Combine
import _PhotosUI_SwiftUI
import Mixpanel

class CaptionViewModel:
    ObservableObject {
    @Published var isButtonEnabled: Bool = false
    @Published var isKeywordModal: Bool = false
    @Published var isOpenPhoto: Bool = false
    @Published var coinAlert: Bool = false
    @Published var selectedKeywords: [String] = []
    @Published var firstSegmentSelected: [String] = []
    @Published var secondSegmentSelected: [String] = []
    @Published var thirdSegmentSelected: [String] = []
    @Published var customKeyword: [String] = []
    @Published var cancellabes = Set<AnyCancellable>()
    @Published var selectedImage: [UIImage] = []
    
}
