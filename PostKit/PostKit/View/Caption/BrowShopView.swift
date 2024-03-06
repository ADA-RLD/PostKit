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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
            print()
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

#Preview {
    BrowShopView()
}
