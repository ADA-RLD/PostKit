//
//  HairView.swift
//  PostKit
//
//  Created by Kim Andrew on 3/5/24.
//

import SwiftUI
import CoreData
import Combine

struct HairView: View {
    @EnvironmentObject var pathManager: PathManager
    @State private var isActive: Bool = false
    @State private var hairName = ""
    @State private var openPhoto : Bool = false
    @State private var selectedImage : [UIImage] = []
    @State private var selectedImageUrl : URL?
    @State private var selectedImageFileName : String?
    @State private var firstSelected: [String] = []
    @State private var secondSelected: [String] = []
    @State private var thirdSelected: [String] = []
    @State private var customKeyword: [String] = []
    @State private var showAlert: Bool = false
    @State private var isModalPresented: Bool = false
    @State private var isSelected: [String] = []
    @State private var textLength: Int = 1
    
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var loadingModel = LoadingViewModel.shared
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    @State var cancellables = Set<AnyCancellable>()
    
    let textLengthArr: [Int] = [100, 200, 300]
    
    var body: some View {
        ZStack {
            VStack(alignment:.leading, spacing: 0) {
                headerArea()
                ScrollView{
                    contents()
                        .sheet(isPresented: $openPhoto) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$selectedImage, imageUrl: $selectedImageUrl, fileName: $selectedImageFileName)
                    }
                    Spacer()
                }
                bottomArea()
            }
            .sheet(isPresented: $isModalPresented, content: {
                //MARK: 키워드 수정
                KeywordModal(selectKeyWords: $isSelected, firstSegementSelected: $firstSelected, secondSegementSelected: $secondSelected, thirdSegementSelected: $thirdSelected, customKeywords: $customKeyword, modalType: .hair ,pickerList: ["느낌","스타일","날씨"])
                    .presentationDragIndicator(.visible)
                    .onDisappear {
                        if hairName.count > 0 && !isSelected.isEmpty {
                            isActive = true
                        }
                    }
            })
            .onTapGesture {
                hideKeyboard()
            }
            if showAlert {
                CustomAlertMessage(alertTopTitle: "크레딧을 모두 사용했어요", alertContent: "크레딧이 있어야 생성할 수 있어요\n크레딧은 자정에 충전돼요", topBtnLabel: "확인") {pathManager.path.removeAll()}
                }
            }
        .navigationBarBackButtonHidden()
    }
}

extension HairView {
    private func headerArea() -> some View {
        CustomHeader(action: {pathManager.path.removeLast()}, title: "헤어 글")
    }
    
    private func contents() -> some View {
        ContentArea {
            VStack(alignment: .leading, spacing: 40) {
                //menuInput()
                
                KeywordAppend(isModalToggle: $isModalPresented, selectKeyWords: $isSelected, openPhoto: $openPhoto, selectedImage: $selectedImage)
                
                SelectTextLength(selected: $textLength)
            }
        }
    }
    
    private func menuInput() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("스타일")
                .body1Bold(textColor: .gray5)
            CustomTextfield(text: $hairName, placeHolder: "스타일 예시")
                .onChange(of: hairName)  { _ in
                    if hairName.count > 0 && !isSelected.isEmpty {
                        isActive = true
                    } else {
                        isActive = false
                    }
                }
        }
    }
    
    private func bottomArea() -> some View {
        CTABtn(btnLabel: "글 생성", isActive: $isActive, action: {
            if coinManager.coin >= CoinManager.captionCost {
                pathManager.path.append(.Loading)
                if selectedImage.count >= 1 {
                    
                }
                else {
                    Task{
                        loadingModel.isCaptionGenerate = false
                        //선택된 옵션들을 가져갑니다.
                        loadingModel.inputArray = [isSelected, firstSelected, secondSelected, thirdSelected].flatMap { $0 }
                        loadingModel.inputArray = removeDuplicates(from: loadingModel.inputArray)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                            sendMessage(coffeeSelected: firstSelected, dessertSelected: secondSelected, drinkSelected: thirdSelected, menuName: hairName, customKeywords: customKeyword, textLenth: textLengthArr[textLength])
                        }
                    }
                }
                
            }
            else {
                showAlert = true
            }
        })
    }
    
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
