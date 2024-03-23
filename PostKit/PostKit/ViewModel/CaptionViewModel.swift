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
    @Published var selectedImageUrl: URL?
    @Published var selectedImageFileName : String?
    @Published var textLength: Int = 200
    
    func checkConditions(enable isButtonEnabled: Bool, keywords  selectedKeywords: [String], image selectedImage: [UIImage]) {
        
        DispatchQueue.main.async {
            if !(selectedImage.isEmpty && selectedImage.isEmpty) {
                self.isButtonEnabled = true
            }
        }
    }

    func deleteKeywords(keywords: String) {
        if firstSegmentSelected.contains(keywords) {
            self.firstSegmentSelected.removeAll(where: {$0 == keywords})
            self.selectedKeywords.removeAll(where: {$0 == keywords})
        }
        else if secondSegmentSelected.contains(keywords) {
            self.secondSegmentSelected.removeAll(where: {$0 == keywords})
            self.selectedKeywords.removeAll(where: {$0 == keywords})
        }
        else if thirdSegmentSelected.contains(keywords) {
            self.thirdSegmentSelected.removeAll(where: {$0 == keywords})
            self.selectedKeywords.removeAll(where: {$0 == keywords})
        }
        else if customKeyword.contains(keywords) {
            self.customKeyword.removeAll(where: {$0 == keywords})
            self.selectedKeywords.removeAll(where: {$0 == keywords})
        }
        
    }
}
