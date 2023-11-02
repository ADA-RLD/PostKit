//
//  KeywordModal.swift
//  PostKit
//
//  Created by 김다빈 on 11/2/23.
//

import SwiftUI

struct KeywordModal: View {
    @Binding var selectKeyWords: [String]
    @Environment(\.presentationMode) var presentationMode
    @State private var inputText: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var pickerSelection: Int = 0
    @State private var coffeePoint = coffeeKeys.map { $0.name}
    @State private var drinkPoint = drinkKeys.map { $0.name}
    @State private var dessertPoint = dessertKeys.map { $0.name}
    let pickerList: [String] = ["커피","음료","디저트"]
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
                if !inputText.isEmpty && selectKeyWords.count <= 5 {
                    selectKeyWords.append(inputText)
                }
                else if selectKeyWords.count > 5 {
                    isShowingAlert = true
                }
            }
            
            if !selectKeyWords.isEmpty {
                WrappingHStack(alignment: .leading) {
                    ForEach(selectKeyWords, id: \.self) { i in
                        CustomHashtag(tagText: i) {
                            selectKeyWords.removeAll(where: { $0 == i})
                            
                            if let coffeeTmp = coffeeKeys.firstIndex(where: { $0.name == i }) {
                                coffeePoint.insert(i, at: coffeeTmp)
                            } else if let drinkTmp = drinkKeys.firstIndex(where: { $0.name == i}) {
                                drinkPoint.insert(i, at: drinkTmp)
                            } else if let dessertTmp = dessertKeys.firstIndex(where: { $0.name == i}) {
                                dessertPoint.insert(i, at: dessertTmp)
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
                    ForEach(coffeePoint, id: \.self) { i in
                        segementationElement(point: i)
                    }
                }
               
            }
            else if (pickerSelection == 1) {
                WrappingHStack(alignment: .leading) {
                    ForEach(drinkPoint, id: \.self) { i in
                        segementationElement(point: i)
                    }
                }
                
            }
            else {
                WrappingHStack(alignment: .leading) {
                    ForEach(dessertPoint, id: \.self) { i in
                        segementationElement(point: i)
                    }
                }
                
            }
         
        }
    }
    
    private func segementationElement(point: String) -> some View {
        Button {
            if selectKeyWords.count < 5 {
                selectKeyWords.append(point)
                if coffeePoint.contains(point) {
                    coffeePoint.removeAll(where: { $0 == point})
                }
                else if dessertPoint.contains(point) {
                    dessertPoint.removeAll(where: { $0 == point})
                }
                else if drinkPoint.contains(point) {
                    drinkPoint.removeAll(where: { $0 == point})
                }
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
