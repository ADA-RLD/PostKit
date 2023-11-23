//
//  Ex+UINaivgationController.swift
//  PostKit
//
//  Created by 김다빈 on 10/31/23.
//

import SwiftUI


class AppState {
    static let shared = AppState()

    var swipeEnabled = false
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if AppState.shared.swipeEnabled {
            return viewControllers.count > 1
        }
        return false
    }
    
}
