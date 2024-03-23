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
            .sheet(isPresented: $captionViewModel.isKeywordModal) {
                KeywordModal(selectKeyWords: $captionViewModel.selectedKeywords, firstSegementSelected: $captionViewModel.firstSegmentSelected, secondSegementSelected: $captionViewModel.secondSegmentSelected, thirdSegementSelected: $captionViewModel.thirdSegmentSelected, customKeywords: $captionViewModel.customKeyword, modalType: categoryName, pickerList: categoryName.picekrList)
            }
        }
        .navigationBarBackButtonHidden()
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
                KeywordAppend(captionViewModel: captionViewModel, isModalToggle: $captionViewModel.isKeywordModal, selectKeyWords: $captionViewModel.selectedKeywords, openPhoto: $captionViewModel.isOpenPhoto, selectedImage: $captionViewModel.selectedImage)
                
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
