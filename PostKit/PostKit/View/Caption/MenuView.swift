//
//  MenuView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI
import CoreData
import Combine

struct MenuView: View {
    @EnvironmentObject var pathManager: PathManager
    @State private var isActive: Bool = false
    @State private var menuName = ""
    @State private var isCoffeeOpened = true
    @State private var isDrinkOpened = false
    @State private var isDessertOpened = false
    @State private var openPhoto : Bool = false
    @State private var selectedImage : [UIImage] = []
    @State private var selectedImageUrl : URL?
    @State private var selectedImageFileName : String?
    @State private var coffeeSelected: [String] = []
    @State private var drinkSelected: [String] = []
    @State private var dessertSelected: [String] = []
    @State private var customKeyword: [String] = []
    @State private var showAlert: Bool = false
    @State private var isModalPresented: Bool = false
    @State private var isSelected: [String] = []
    @State private var textLength: Int = 1
    
    @ObservedObject var captionViewModel = CaptionViewModel.shared
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
                KeywordModal(captionViewModel: captionViewModel, selectKeyWords: $isSelected, firstSegementSelected: $coffeeSelected, secondSegementSelected: $drinkSelected, thirdSegementSelected: $dessertSelected, customKeywords: $customKeyword, modalType: .cafe ,pickerList: ["커피","음료","디저트"])
                    .presentationDragIndicator(.visible)
                    .onDisappear {
                        if menuName.count > 0 && (!isSelected.isEmpty || selectedImage.count >= 1) {
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

extension MenuView {
    private func headerArea() -> some View {
        CustomHeader(action: {pathManager.path.removeLast()}, title: "메뉴 글")
    }
    
    private func contents() -> some View {
        ContentArea {
            VStack(alignment: .leading, spacing: 40) {
                menuInput()

                KeywordAppend(captionViewModel: captionViewModel, isModalToggle: $isModalPresented, selectKeyWords: $isSelected, openPhoto: $openPhoto, selectedImage: $selectedImage)

                SelectTextLength(selected: $textLength)
            }
        }
    }
    
    private func menuInput() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("메뉴 이름")
                .body1Bold(textColor: .gray5)
            CustomTextfield(text: $menuName, placeHolder: "아이스 아메리카노")
                .onChange(of: menuName)  { _ in
                    if menuName.count > 0 && !isSelected.isEmpty {
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
                        Task{
                            loadingModel.isCaptionGenerate = false
                            //선택된 옵션들을 가져갑니다.
                            loadingModel.inputArray = [isSelected, coffeeSelected, dessertSelected, drinkSelected].flatMap { $0 }
                            loadingModel.inputArray = removeDuplicates(from: loadingModel.inputArray)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                                sendVisionMessage(coffeeSelected: coffeeSelected, dessertSelected: dessertSelected, drinkSelected: drinkSelected, menuName: menuName, customKeywords: customKeyword, textLenth: textLengthArr[textLength], images: selectedImage)
                            }
                        }
                    }
                    else {
                        Task{
                            loadingModel.isCaptionGenerate = false
                            //선택된 옵션들을 가져갑니다.
                            loadingModel.inputArray = [isSelected, coffeeSelected, dessertSelected, drinkSelected].flatMap { $0 }
                            loadingModel.inputArray = removeDuplicates(from: loadingModel.inputArray)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                                sendMessage(coffeeSelected: coffeeSelected, dessertSelected: dessertSelected, drinkSelected: drinkSelected, menuName: menuName, customKeywords: customKeyword, textLenth: textLengthArr[textLength])
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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//#Preview {
//    MenuView()
//}
