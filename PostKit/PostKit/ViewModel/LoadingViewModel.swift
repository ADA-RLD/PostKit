//
//  LoadingViewModel.swift
//  PostKit
//
//  Created by Kim Andrew on 11/6/23.
//

import Foundation

final class LoadingViewModel: ObservableObject {
    
    static let shared = LoadingViewModel(isCaptionGenerate: false, inputArray: [])
    
    @Published var isCaptionGenerate: Bool
    @Published var inputArray: [String]
    
    init(isCaptionGenerate: Bool, inputArray: [String]) {
        self.isCaptionGenerate = isCaptionGenerate
        self.inputArray = inputArray
    }
    
}
