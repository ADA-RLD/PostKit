//
//  CaptionView.swift
//  PostKit
//
//  Created by 김다빈 on 3/23/24.
//

import SwiftUI

struct CaptionView: View {
    @EnvironmentObject var pathManager: PathManager
    @ObservedObject var captionViewModel = CaptionViewModel.shared
    @StateObject var storeModel : StoreModel
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var loadingModel = LoadingViewModel.shared
    @State private var showAlert: Bool = false
    
    var categoryName: categoryType
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerArea
                contentsArea
                Spacer()
                bottomArea
            }
            .sheet(isPresented: $captionViewModel.isOpenPhoto) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $captionViewModel.selectedImage,imageUrl: $captionViewModel.selectedImageUrl, fileName: $captionViewModel.selectedImageFileName)
            }
            .onReceive((captionViewModel.$selectedImage), perform: { _ in
                DispatchQueue.main.async {
                    captionViewModel.checkConditions()
                    
                }
            })
            .onReceive(captionViewModel.$selectedKeywords, perform: { _ in
                captionViewModel.checkConditions()
            })
            
            .sheet(isPresented: $captionViewModel.isKeywordModal) {
                KeywordModal(captionViewModel: captionViewModel, selectKeyWords: $captionViewModel.selectedKeywords, firstSegementSelected: $captionViewModel.firstSegmentSelected, secondSegementSelected: $captionViewModel.secondSegmentSelected, thirdSegementSelected: $captionViewModel.thirdSegmentSelected, customKeywords: $captionViewModel.customKeyword, modalType: categoryName, pickerList: categoryName.picekrList)
                
            }
            if showAlert {
                CustomAlertMessage(alertTopTitle: "크레딧을 모두 사용했어요", alertContent: "크레딧이 있어야 생성할 수 있어요\n크레딧은 자정에 충전돼요", topBtnLabel: "확인") {pathManager.path.removeAll()}
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
                
                SelectTextLength(selected: $captionViewModel.textLength )
            }
        }
    }
    
    // MARK: BottomArea
    private var bottomArea: some View {
        CTABtn(btnLabel: "글 생성", isActive: $captionViewModel.isButtonEnabled) {
            if coinManager.checkCoin() {
                captionViewModel.checkCategory(category: categoryName.korCategoryName)
                pathManager.path.append(.Loading)
                Task {
                    DispatchQueue.main.async {
                        loadingModel.isCaptionGenerate = false
                    }
                    if captionViewModel.isImage() {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            captionViewModel.createVisionPrompt(storeName: storeModel.storeName, storeInfo: categoryName.korCategoryName, toneInfo: storeModel.tone, segmentInfo: categoryName.picekrList)
                            captionViewModel.sendVisionMessage()
                        }
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            captionViewModel.createPrompt(storeName: storeModel.storeName, storeInfo: categoryName.korCategoryName, toneInfo: storeModel.tone, segmentInfo: categoryName.picekrList)
                            captionViewModel.sendMessage()
                        }
                    }
                }
            }
            else {
                showAlert = true
                
            }
        }
        .onReceive(captionViewModel.$isCaptionSuccess, perform: { _ in
            print(captionViewModel.isCaptionSuccess)
            if captionViewModel.isCaptionSuccess == true {
                DispatchQueue.main.async {
                    loadingModel.isCaptionGenerate = false
                    pathManager.path.append(.CaptionResult)
                    coinManager.coinCaptionUse()
                }
            }
        })
        .onReceive(captionViewModel.$errorCode, perform: { _ in
            print(captionViewModel.errorCode)
            if captionViewModel.errorCode == 10 {
                DispatchQueue.main.async {
                    loadingModel.isCaptionGenerate = true
                    pathManager.path.append(.ErrorResultFailed)
                }
            } else if captionViewModel.errorCode == 13{
                DispatchQueue.main.async {
                    pathManager.path.append(.ErrorNetwork)
                }
            }
        })
    }
}

