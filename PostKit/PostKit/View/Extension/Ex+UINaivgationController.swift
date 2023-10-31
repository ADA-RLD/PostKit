//
//  Ex+UINaivgationController.swift
//  PostKit
//
//  Created by 김다빈 on 10/31/23.
//

import SwiftUI

extension UINavigationController : UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.isHidden = true
    }
    
    // MARK: Navigation Stack에 쌓인 뷰가 1개를 초과해야 제스처가 동작하도록
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
