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
        VStack(alignment: .leading, spacing: 24) {
            Text("글 길이")
                .body1Bold(textColor: .gray5)
            
            HStack(spacing: 32) {
                ForEach(Array(textLength.enumerated()), id: \.offset) { idx, item in
                    RaidioBtn(title: item, id: idx, selectedId: self.$selected)
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
                if selectedId == id {
                    Image(.checkMono)
                }
                else if selectedId != id {
                    Image(.emptyMono)
                }

            })
            
            // TODO: 코드 개선 필요
            if self.selectedId != self.id {
                Text(title)
                    .body1Bold(textColor: .gray4)
            }
            else {
                Text(title)
                    .body1Bold(textColor: .gray5)
            }
        }
    }
}
