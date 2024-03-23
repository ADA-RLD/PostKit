//
//  CaptionView.swift
//  PostKit
//
//  Created by 김다빈 on 3/23/24.
//

import SwiftUI

struct CaptionView: View {
    @EnvironmentObject var pathManager: PathManager
    @StateObject var captionViewModel = CaptionViewModel()
    var categoryName: categoryType
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerArea
                contentsArea
                Spacer()
                bottomArea
            }
        }
    }
}

extension CaptionView {
    // MARK: HeaderArea
    private var headerArea: some View {
        CustomHeader(action: {
            pathManager.path.removeLast()
        }, title: categoryName.korCategoryName)
    }
    
    // MARK: ContentsArea
    private var contentsArea: some View {
        ContentArea {
            VStack(alignment: .leading, spacing: 40) {
                
            }
        }
    }
    
    // MARK: BottomArea
    private var bottomArea: some View {
        CTABtn(btnLabel: "글 생성", isActive: $captionViewModel.isButtonEnabled) {
            print("")
        }
    }
}

#Preview {
    CaptionView( categoryName: .cafe)
}
