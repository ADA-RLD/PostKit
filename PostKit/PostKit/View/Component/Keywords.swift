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
                                .font(.system(size: 13))
                                .foregroundStyle(selectedIndices.contains(keyName[index]) ? Color.pink : Color.gray)
                                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .background(selectedIndices.contains(keyName[index]) ? Color.gray1 : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(selectedIndices.contains(keyName[index]) ? Color.pink : Color.gray3)
                                }
                        }
                        
                    })
                    
                }
            }
            .padding(.leading,20)
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
