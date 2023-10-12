//
//  OnboardingRouter.swift
//  PostKit
//
//  Created by 김다빈 on 10/12/23.
//

import SwiftUI

class OnboardingRouter: ObservableObject {
    static let shared = OnboardingRouter()
    private init() {}
    
    @Published var currentPage: Int = 0
    
    func nextPage() {
        currentPage += 1
    }
    func previousPage() {
        currentPage -= 1
    }
}
