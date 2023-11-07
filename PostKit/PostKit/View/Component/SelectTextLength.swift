//
//  SelectTextLength.swift
//  PostKit
//
//  Created by 김다빈 on 11/2/23.
//

import SwiftUI

struct SelectTextLength: View {
    @Binding var selected: Int
    
    let textLength: [String] = ["짧음","중간","긺"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("글 길이")
                .font(.body1Bold())
                .foregroundColor(.gray5)
            
            HStack(spacing: 32) {
                ForEach(Array(textLength.enumerated()), id: \.offset) { idx, item in
                    RaidioBtn(title: item, id: idx,selectedId: self.$selected)
                }
            }
        }
    }
}



extension SelectTextLength {
    private func radioGroupCallback(id: Int) {
        selected = id
    }
}
struct RaidioBtn: View {
    
    let id: Int
    let title: String
    @Binding var selectedId: Int
    
    init (
        title: String,
        id: Int,
        selectedId: Binding<Int>
    ) {
        self.title = title
        self.id = id
        self._selectedId = selectedId
    }
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Button(action: {
                self.selectedId = id
                print(selectedId)
            }, label: {
                Circle()
                    .stroke(self.selectedId != self.id ? Color.gray4 : Color.white)
                    .frame(width: 14,height: 14)
                    .background(self.selectedId != self.id ? Color.white : Color.main )
                    .cornerRadius(radius2)
                
            })
            
            Text(title)
                .font(.body1Bold())
                .foregroundColor(Color.gray5)
        }
    }
}
