//
//  KeywordModal.swift
//  PostKit
//
//  Created by 김다빈 on 11/2/23.
//
import Mixpanel
import SwiftUI

enum KeywordModalType {
    case daily
    case menu
}

struct KeywordModal: View {
    private let maxCount: Int = 5
    @Binding var selectKeyWords: [String]
    @Binding var firstSegementSelected: [String]
    @Binding var secondSegementSelected: [String]
    @Binding var thirdSegementSelected: [String]
    @Binding var customKeywords: [String]
    @Environment(\.presentationMode) var presentationMode
    @State private var inputText: String = ""
    @State private var pickerSelection: Int = 0
    @State private var firstSegmentPoint = coffeeKeys.map{$0.name}
    @State private var secondSegmentPoint = drinkKeys.map{$0.name}
    @State private var thirdSegmentPoint = dessertKeys.map{$0.name}
    @State private var weatherPoint = weatherKeys.map {$0.name}
    @State private var coffeeDrinkPoint = dailyCoffeeKeys.map{$0.name}
    @State private var dailyDessertPoint = dailyDessertKeys.map{$0.name}
    @State private var isShowingToast = false
    @State private var keyboardHeight: CGFloat = 0
    @Namespace var nameSpace
    
    var modalType: KeywordModalType = .daily
    
    var pickerList: [String]
    var body: some View {
        ZStack {
            VStack() {
                headerArea()
                
                ScrollView {
                    ContentArea {
                        VStack(alignment: .leading, spacing: 28) {
                            keywordInputArea()
                            
                            segementaionArea()
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                Spacer()
            }
            .toast(toastText: "5개까지 추가할 수 있어요", toastImgRes: Image(.exclamation), isShowing: $isShowingToast)
            .onAppear {
                if modalType == .daily {
                    firstSegmentPoint = weatherKeys.map { $0.name}
                    secondSegmentPoint = dailyCoffeeKeys.map { $0.name}
                    thirdSegmentPoint = dailyDessertKeys.map { $0.name}
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                    .map {$0.userInfo![UIResponder.keyboardFrameEndUserInfoKey]as!CGRect}
                    .map{$0.height}
            ) { height in
                keyboardHeight = height
            }
            .onReceive(
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    keyboardHeight = 0
                }
        }
 
    }
}

extension KeywordModal {
    private func headerArea() -> some View {
        HStack {
            Button {
                selectKeyWords = []
                firstSegementSelected = []
                secondSegementSelected = []
                thirdSegementSelected = []
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("취소")
                    .body1Bold(textColor: .main)
            }
            Spacer()
            Text("키워드 추가")
                .font(.system(size: 17, weight: .semibold))
            Spacer()
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("저장")
                    .body1Bold(textColor: .main)
            }
        }
        .frame(height: 44)
        .padding(.top,14)
        .padding(.horizontal, 16)
    }
    
    private func keywordInputArea() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            CustomTextfield(text: $inputText, placeHolder: "크리스마스", customTextfieldState: .reuse) {
                if (!inputText.isEmpty && selectKeyWords.count < maxCount && !firstSegmentPoint.contains(inputText) && !secondSegmentPoint.contains(inputText) && !thirdSegmentPoint.contains(inputText)) {
                    selectKeyWords.append(inputText)
                    customKeywords.append(inputText)
                }
            }
            .onSubmit {
                if selectKeyWords.count >= maxCount {
                    isShowingToast = true
                }
                if modalType == .daily {
                    Mixpanel.mainInstance().track(event: "커스텀 키워드 입력", properties:["카테고리": "일상"])
                }
                else if modalType == .menu {
                    Mixpanel.mainInstance().track(event: "커스텀 키워드 입력", properties:["카테고리": "메뉴"])
                }
            }
            
            if !selectKeyWords.isEmpty {
                WrappingHStack(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
                    ForEach(selectKeyWords, id: \.self) { i in
                        CustomHashtag(tagText: i) {
                            selectKeyWords.removeAll(where: { $0 == i})
                            
                            if firstSegementSelected.contains(i) {
                                firstSegementSelected.removeAll(where: { $0 == i})
                            }
                            else if secondSegementSelected.contains(i) {
                                secondSegementSelected.removeAll(where: {$0 == i})
                            }
                            else if thirdSegementSelected.contains(i) {
                                thirdSegementSelected.removeAll(where: {$0 == i})
                            }
                            
                            if modalType == .menu {
                                if let coffeeTmp = coffeeKeys.firstIndex(where: { $0.name == i }) {
                                    firstSegmentPoint.insert(i, at: coffeeTmp)
                                } else if let drinkTmp = drinkKeys.firstIndex(where: { $0.name == i}) {
                                    secondSegmentPoint.insert(i, at: drinkTmp)
                                } else if let dessertTmp = dessertKeys.firstIndex(where: { $0.name == i}) {
                                    thirdSegmentPoint.insert(i, at: dessertTmp)
                                }
                            } else {
                                if let coffeeTmp = weatherKeys.firstIndex(where: { $0.name == i }) {
                                    firstSegmentPoint.insert(i, at: coffeeTmp)
                                } else if let drinkTmp = dailyCoffeeKeys.firstIndex(where: { $0.name == i}) {
                                    secondSegmentPoint.insert(i, at: drinkTmp)
                                } else if let dessertTmp = dailyDessertKeys.firstIndex(where: { $0.name == i}) {
                                    thirdSegmentPoint.insert(i, at: dessertTmp)
                                }
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    private func segementaionArea() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("추천 키워드")
                .body2Bold(textColor: .gray5)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 0) {
                    ForEach(pickerList.indices, id: \.self ) { selected in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                pickerSelection = selected
                            }
                        } label: {
                            Text(pickerList[selected])
                                .font(pickerSelection == selected ? .system(size: 13, weight: .semibold) : .system(size: 13, weight: .regular))
                                .foregroundColor(.gray5)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background {
                                    if pickerSelection == selected {
                                        RoundedRectangle(cornerRadius: radius2)
                                            .matchedGeometryEffect(id: "activeBackGround", in: nameSpace)
                                            .foregroundColor(pickerSelection == selected ? .white : .gray2)
                                    }
                                }
                        }
                        .tag(pickerSelection)
                    }
                    
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 4)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: radius2)
                        .foregroundColor(Color.gray2)
                }
                
                WrappingHStack(alignment: .leading, horizontalSpacing: 8,verticalSpacing: 8){
                    switch pickerSelection {
                    case 0:
                        ForEach(firstSegmentPoint, id: \.self) { i in
                            segementationElement(point: i)
                        }
                    case 1:
                        ForEach(secondSegmentPoint, id: \.self) { i in
                            segementationElement(point: i)
                        }
                    case 2:
                        ForEach(thirdSegmentPoint, id: \.self) { i in
                            segementationElement(point: i)
                        }
                    default:
                        ForEach(firstSegmentPoint, id: \.self) { i in
                            segementationElement(point: i)
                        }
                    }
                }
            }
        }
    }
    
    private func segementationElement(point: String) -> some View {
        Button {
            if selectKeyWords.count < maxCount {
                if firstSegmentPoint.contains(point) {
                    firstSegementSelected.append(point)
                    firstSegmentPoint.removeAll(where: { $0 == point})
                }
                else if thirdSegmentPoint.contains(point) {
                    thirdSegementSelected.append(point)
                    thirdSegmentPoint.removeAll(where: { $0 == point})
                }
                else if secondSegmentPoint.contains(point) {
                    secondSegementSelected.append(point)
                    secondSegmentPoint.removeAll(where: { $0 == point})
                }
                selectKeyWords.append(point)
            }
            else {
                isShowingToast = true
            }
        } label: {
            Text(point)
                .body2Regular(textColor: .gray4)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .clipShape(RoundedRectangle(cornerRadius: radius1))
                .overlay() {
                    RoundedRectangle(cornerRadius: radius1)
                        .stroke(Color.gray3, lineWidth: 1)
                }
        }
    }
}
//
//#Preview {
//    KeywordModal(selectKeyWords: .constant([]))
//}
