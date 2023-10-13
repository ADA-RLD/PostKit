//
//  Keywords.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI

struct Keywords: View {
    @State var keyName: [String]
    @Binding var selectedIndices: [String]
    
    var body: some View {
        VStack {
            WrappingHStack(alignment: .leading) {
                ForEach(keyName.indices, id: \.self) { index in
                    Button( action: {
                        toggleSelection(selectedValue: keyName[index])
                    }, label: {
                        HStack {
                            Text(keyName[index])
                                .font(.body2Regular())
                                .foregroundStyle(selectedIndices.contains(keyName[index]) ? Color.main : Color.gray4)
                                .padding(EdgeInsets(top: 8, leading: radius1, bottom: 8, trailing: radius1))
                                .background(selectedIndices.contains(keyName[index]) ? Color.sub : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: radius1))
                                .overlay {
                                    if selectedIndices.contains(keyName[index]){
                                        RoundedRectangle(cornerRadius: radius1)
                                        .stroke(Color.main,lineWidth: 2)
                                    } else {
                                        RoundedRectangle(cornerRadius: radius1)
                                        .stroke(Color.gray3,lineWidth: 1)
                                    }
                              }
                        }
                        
                    })
                    
                }
            }
            .padding(EdgeInsets(top: 12, leading: paddingHorizontal, bottom: 30, trailing: 0))
        }
    }
    

    private func toggleSelection(selectedValue: String) {
        if selectedIndices.contains(selectedValue) {
            selectedIndices.removeAll(where: { $0 == selectedValue })
        } else {
            selectedIndices.append(selectedValue)
        }
    }
}


//#Preview {
//    Keywords(keyName: [])
//}
