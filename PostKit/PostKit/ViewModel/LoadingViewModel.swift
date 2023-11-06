//
//  LoadingViewModel.swift
//  PostKit
//
//  Created by Kim Andrew on 11/6/23.
//

import Foundation

final class LoadingViewModel: ObservableObject {
    
    static let shared = LoadingViewModel(isCaptionGenerate: false)
    
    @Published var isCaptionGenerate: Bool
    
    init(isCaptionGenerate: Bool) {
        self.isCaptionGenerate = isCaptionGenerate
    }
}
