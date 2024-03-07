//
//  BrwoShopView.swift
//  PostKit
//
//  Created by 김다빈 on 3/6/24.
//

import SwiftUI
import CoreData
import Combine
import _PhotosUI_SwiftUI

struct BrowShopView: View {
    
    @EnvironmentObject var pathManager: PathManager
    @State private var isActive: Bool = false
    @State private var isSelected: [String] = []
    @State private var isModalPresented: Bool = false
    @State private var openPhoto: Bool = false
    @State private var textLength: Int = 1
    @State private var showAlert: Bool = false
    @State private var selectedImage : [UIImage] = []
    @State private var selectedImageUrl : URL?
    @State private var selectedImageFileName : String?
    @State private var customKeyword: [String] = []
    @State private var firstSegmentSelected: [String] = []
    @State private var secondSegmentSelected: [String] = []
    @State private var thirdSegementSelected: [String] = []
    @State var cancellables = Set<AnyCancellable>()
    
    // CoreData Data class
    @StateObject var storeModel: StoreModel
    
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var loadingModel = LoadingViewModel.shared
    
    // CoreData Manager
    let storeDataManager = CoreDataManager.instance
    let textLengthArr: [Int] = [100, 200, 300]
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerArea()
                contents()
                    .sheet(isPresented: $openPhoto) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$selectedImage, imageUrl: $selectedImageUrl, fileName: $selectedImageFileName)
                    }
                Spacer()
                bottomArea()
            }
            .sheet(isPresented: $isModalPresented) {
                // TODO: 키워드가 정해지면 바꿔야 합니다.
                KeywordModal(selectKeyWords: $isSelected, firstSegementSelected: $firstSegmentSelected, secondSegementSelected: $secondSegmentSelected, thirdSegementSelected: $thirdSegementSelected, customKeywords: $customKeyword, modalType: .daily, pickerList: ["특징", "스타일", "일상"])
                    .presentationDragIndicator(.visible)
            }
            if showAlert {
                CustomAlertMessage(alertTopTitle: "크레딧을 모두 사용했어요", alertContent: "크레딧이 있어야 생성할 수 있어요\n크레딧은 자정에 충전돼요", topBtnLabel: "확인") {pathManager.path.removeAll()}
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            isActive = true
        }
    }
}

// MARK: View의 모듈화를 위한 extension모음
extension BrowShopView {
    //MARK: Header
    private func headerArea() -> some View {
        CustomHeader(action: {pathManager.path.removeLast()}, title: "브로우샵 글")
    }
    
    //MARK: ContentArea
    private func contents() -> some View {
        ContentArea {
            VStack(alignment: .leading, spacing: 40) {
                KeywordAppend(isModalToggle: $isModalPresented, selectKeyWords: $isSelected, openPhoto: $openPhoto, selectedImage: $selectedImage)
                    .onChange(of: isSelected) { _ in
                        isActive = true
                    }
                
                SelectTextLength(selected: $textLength)
            }
        }
    }
    
    //MARK: BotomArea
    private func bottomArea() -> some View {
        CTABtn(btnLabel: "글 생성", isActive: $isActive) {
            if coinManager.coin >= CoinManager.captionCost {
                pathManager.path.append(.Loading)
                
                if selectedImage.count > 0 {
                    Task {
                        loadingModel.isCaptionGenerate = false
                        loadingModel.inputArray = [isSelected,firstSegmentSelected,secondSegmentSelected,thirdSegementSelected].flatMap { $0 }
                        loadingModel.inputArray = removeDuplicates(from: loadingModel.inputArray)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                            sendVisionMessage(firstSegmentSelected: firstSegmentSelected, secondSegmentSelected: secondSegmentSelected, thirdSegmentSelected: thirdSegementSelected, customKeywords: customKeyword, textLength: textLength, images: selectedImage)
                        }
                    }
                }
                else {
                    Task {
                        loadingModel.isCaptionGenerate = false
                        loadingModel.inputArray = [isSelected,firstSegmentSelected,secondSegmentSelected,thirdSegementSelected].flatMap { $0 }
                        loadingModel.inputArray = removeDuplicates(from: loadingModel.inputArray)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                            sendMessage(firstSegmentSelected: firstSegmentSelected, secondSegmentSelected: secondSegmentSelected, thirdSegmentSelected: thirdSegementSelected, customKeywords: customKeyword, textLength: textLength)
                        }
                    }
                }
            } else {
                showAlert = true
            }
        }
    }
    
    //MARK: 이미지 배열 해제 함수
    private func removeDuplicates(from array: [String]) -> [String] {
        var uniqueArray: [String] = []
        
        for element in array {
            if !uniqueArray.contains(element) {
                uniqueArray.append(element)
            }
        }
        return uniqueArray
    }
}
