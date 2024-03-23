//
//  KeywordModal.swift
//  PostKit
//
//  Created by 김다빈 on 11/2/23.
//
import Mixpanel
import SwiftUI

public enum KeywordModalType {
    case daily
    case menu
    case goods
    case fassion
    case hair
    case browshop
}

struct KeywordModal: View {
//    @ObservedObject var captionViewModel: CaptionViewModel
    private let firebaseManager = FirebaseManager()
    private let maxCount: Int = 5
    @Binding var selectKeyWords: [String]
    @Binding var firstSegementSelected: [String]
    @Binding var secondSegementSelected: [String]
    @Binding var thirdSegementSelected: [String]
    @Binding var customKeywords: [String]
    @Environment(\.presentationMode) var presentationMode
    @State private var inputText: String = ""
    @State private var pickerSelection: Int = 0
    @State private var selectModalKeywords: [String] = []
    @State private var firstSegmentPoint: [String] = []
    @State private var secondSegmentPoint: [String] = []
    @State private var thirdSegmentPoint: [String] = []
    @State private var originFirstSegment: [String] = []
    @State private var originSecondSegment: [String] = []
    @State private var originThirdSegment: [String] = []
    @State private var isShowingToast = false
    @State private var keyboardHeight: CGFloat = 0
    @Namespace var nameSpace
    
    var modalType: categoryType
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
                switch modalType {
                case .cafe:
                    getFireBaseArray(keywordType: "CafeKeywords", firstSegmentName: "Section1", secondSegmentName: "Section2", thirdSegmentName: "Section3")
                case .fassion:
                    getFireBaseArray(keywordType: "FashionKeywords", firstSegmentName: "Section1", secondSegmentName: "Section2", thirdSegmentName: "Section3")
                case .hair:
                    getFireBaseArray(keywordType: "HairKeywords", firstSegmentName: "Section1", secondSegmentName: "Section2", thirdSegmentName: "Section3")
                case .browShop:
                    getFireBaseArray(keywordType: "BrowKeywords", firstSegmentName: "Section1", secondSegmentName: "Section2", thirdSegmentName: "Section3")
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
// MARK: Views
extension KeywordModal {
    private func headerArea() -> some View {
        HStack {
            Button {
                selectModalKeywords = []
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
                selectKeyWords = selectModalKeywords
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("저장")
                    .body1Bold(textColor: .main)
            }
        }
        .frame(height: 44)
        .padding(.top,14)
        .padding(.horizontal, 16)
        .onChange(of: selectModalKeywords) { _ in
            selectModalKeywords = removeDuplicates(from: selectModalKeywords)
        }
    }
    
    private func keywordInputArea() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            CustomTextfield(text: $inputText, placeHolder: "크리스마스", customTextfieldState: .reuse) {
                if (!inputText.isEmpty && selectModalKeywords.count < maxCount && !firstSegmentPoint.contains(inputText) && !secondSegmentPoint.contains(inputText) && !thirdSegmentPoint.contains(inputText)) {
                    selectModalKeywords.append(inputText)
                    customKeywords.append(inputText)
                }
            }
            .onSubmit {
                if selectModalKeywords.count >= maxCount {
                    isShowingToast = true
                }
                if modalType == .cafe {
                    Mixpanel.mainInstance().track(event: "커스텀 키워드 입력")
                }
                else if modalType == .browShop {
                    Mixpanel.mainInstance().track(event: "커스텀 키워드 입력")
                }
            }
            
            if !selectModalKeywords.isEmpty {
                WrappingHStack(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
                    ForEach(selectModalKeywords, id: \.self) { i in
                        CustomHashtag(tagText: i) {
                            selectModalKeywords.removeAll(where: { $0 == i})
                            
                            if firstSegementSelected.contains(i) {
                                firstSegementSelected.removeAll(where: { $0 == i})
                            }
                            else if secondSegementSelected.contains(i) {
                                secondSegementSelected.removeAll(where: {$0 == i})
                            }
                            else if thirdSegementSelected.contains(i) {
                                thirdSegementSelected.removeAll(where: {$0 == i})
                            }
                            if let coffeeTmp = originFirstSegment.firstIndex(of: i) {
                                firstSegmentPoint.insert(i, at: coffeeTmp)
                            } else if let drinkTmp = originSecondSegment.firstIndex(of: i) {
                                secondSegmentPoint.insert(i, at: drinkTmp)
                            } else if let dessertTmp = originThirdSegment.firstIndex(of: i) {
                                thirdSegmentPoint.insert(i, at: dessertTmp)
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
            
                WrappingHStack(alignment: .leading, horizontalSpacing: 8,verticalSpacing: 12){
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
            if selectModalKeywords.count < maxCount {
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
                selectModalKeywords.append(point)
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

//MARK: Functions
extension KeywordModal {
    private func getFireBaseArray (keywordType: String, firstSegmentName: String, secondSegmentName: String, thirdSegmentName: String) {
        firebaseManager.getKeyWordsDocument(keyWordType: keywordType, keyWordName: firstSegmentName) { receviedArray in
            self.firstSegmentPoint = receviedArray
            self.originFirstSegment = receviedArray
        }
        firebaseManager.getKeyWordsDocument(keyWordType: keywordType, keyWordName: secondSegmentName) { receviedArray in
            self.secondSegmentPoint = receviedArray
            self.originSecondSegment = receviedArray
        }
        firebaseManager.getKeyWordsDocument(keyWordType: keywordType, keyWordName: thirdSegmentName) { receviedArray in
            self.thirdSegmentPoint = receviedArray
            self.originThirdSegment = receviedArray
        }
    }
}
//
//#Preview {
//    KeywordModal(selectModalKeywords: .constant([]))
//}
