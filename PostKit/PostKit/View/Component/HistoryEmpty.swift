//
//  HistoryEmpty.swift
//  PostKit
//
//  Created by 신서연 on 2023/11/08.
//

import SwiftUI

struct HistoryEmptyView: View {
    @EnvironmentObject var pathManager: PathManager
    var topTitleLable: String
    var bottomTitleLable: String
    var historyImage: ImageResource
    @Binding var selection: Int
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Image(historyImage)
            
            VStack(alignment: .center, spacing: 12) {
                Text(topTitleLable)
                    .title1(textColor: .gray6)
                    .multilineTextAlignment(.center)
                
                Text(bottomTitleLable)
                    .body2Bold(textColor: .gray4)
                    .multilineTextAlignment(.center)
            }
            AlertCustomBtn(topBtnLabel: "글 쓰기", topAction: {selection = 0}
                          )
        }.frame(width: 335, height: 340)
    }
}

//#Preview {
//    HistoryEmptyView(topTitleLable: "아직 글이 없어요", bottomTitleLable: "글을 생성해볼까요?", historyImage: .historyEmpty)
//}
