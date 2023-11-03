//
//  KeywordModal.swift
//  PostKit
//
//  Created by 김다빈 on 11/2/23.
//

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
    @Environment(\.presentationMode) var presentationMode
    @State private var inputText: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var pickerSelection: Int = 0
    @State private var firstSegmentPoint = coffeeKeys.map{$0.name}
    @State private var secondSegmentPoint = drinkKeys.map{$0.name}
    @State private var thirdSegmentPoint = dessertKeys.map{$0.name}
    @State private var weatherPoint = weatherKeys.map {$0.name}
    @State private var coffeeDrinkPoint = dailyCoffeeKeys.map{$0.name}
    @State private var dailyDessertPoint = dailyDessertKeys.map{$0.name}
    
    var modalType: KeywordModalType = .daily
    
    var pickerList: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            headerArea()
            
            ContentArea {
                VStack(alignment: .leading, spacing: 28) {
                    keywordinputArea()
                    
                    segementaionArea()
                }
            }
            Spacer()
        }.onAppear {
            if modalType == .daily {
                firstSegmentPoint = weatherKeys.map { $0.name}
                secondSegmentPoint = dailyCoffeeKeys.map { $0.name}
                thirdSegmentPoint = dailyDessertKeys.map { $0.name}
            }
        }
    }
}

extension KeywordModal {
    private func headerArea() -> some View {
        HStack {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("취소")
                    .font(.system(size: 17, weight: .semibold))
            }
            Spacer()
            Text("키워드 추가")
                .font(.system(size: 17,weight: .semibold))
            Spacer()
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("저장")
                    .font(.system(size: 17, weight: .semibold))
            }
        }
        .padding(.horizontal,16)
        .padding(.top,25)
    }
    
    private func keywordinputArea() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            CustomTextfield(text: $inputText, placeHolder: "키워드를 추가해보세요",customTextfieldState: .reuse) {
                if !inputText.isEmpty && selectKeyWords.count < maxCount {
                    selectKeyWords.append(inputText)
                }
                else if selectKeyWords.count > maxCount {
                    isShowingAlert = true
                }
            }
            
            if !selectKeyWords.isEmpty {
                WrappingHStack(alignment: .leading) {
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
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text(""), message: Text("최대 5개까지만 입력할 수 있습니다."),
                  dismissButton: .default(Text("확인")))
        }
    }
    
    private func segementaionArea() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("추천 키워드")
                .font(.body2Bold())
                .foregroundColor(Color.gray5)
            
            HStack(spacing: 0) {
                Picker("",selection: $pickerSelection) {
                    ForEach(pickerList.indices, id: \.self ) { i in
                        Button {
                            pickerSelection = i
                        } label: {
                            RoundedRectangle(cornerRadius: 7)
                                .foregroundColor(pickerSelection == i ? Color.white : Color.clear)
                                .frame(height: 36)
                                .overlay(alignment: .center) {
                                    Text(pickerList[i])
                                        .font(pickerSelection == i ? .system(size: 17,weight: .semibold) : .system(size: 17,weight: .regular))
                                }
                        }
                        .tag(i)
                        
                    }
                }
                .frame(height: 40)
                .pickerStyle(.segmented)
            }
            
            if (pickerSelection == 0) {
                WrappingHStack(alignment: .leading) {
                    ForEach(firstSegmentPoint, id: \.self) { i in
                        segementationElement(point: i)
                    }
                }
               
            }
            else if (pickerSelection == 1) {
                WrappingHStack(alignment: .leading) {
                    ForEach(secondSegmentPoint, id: \.self) { i in
                        segementationElement(point: i)
                    }
                }
                
            }
            else {
                WrappingHStack(alignment: .leading) {
                    ForEach(thirdSegmentPoint, id: \.self) { i in
                        segementationElement(point: i)
                    }
                }
                
            }
         
        }
    }
    
    private func segementationElement(point: String) -> some View {
        Button {
            if selectKeyWords.count < maxCount {
                if modalType == .menu {
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
                }
                selectKeyWords.append(point)
            }
            else {
                isShowingAlert.toggle()
            }
        } label: {
            Text(point)
                .font(.body2Regular())
                .foregroundColor(Color.gray4)
                .padding(EdgeInsets(top: 8, leading: radius1, bottom: 8, trailing: radius1))
                .clipShape(RoundedRectangle(cornerRadius: radius1))
                .overlay() {
                    RoundedRectangle(cornerRadius: radius1)
                    .stroke(Color.gray3,lineWidth: 1)
                    
                }
        }

      
    }
}
//
//#Preview {
//    KeywordModal(selectKeyWords: .constant([]))
//}
