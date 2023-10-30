//
//  HashtagResultView.swift
//  PostKit
//
//  Created by 김다빈 on 10/30/23.
//

import SwiftUI

struct HashtagResultView: View {
    private let pasteBoard = UIPasteboard.general
    @State private var isShowingToast = false
    @EnvironmentObject var pathManager: PathManager
    private let dummidata: String = "#서울카페 #서울숲카페 #서울숲브런치맛집 #성\n수동휘낭시에 #성수동여행 #서울숲카페탐방 #성\n수동디저트 #성수동감성카페 #서울신상카페 #서\n울숲카페거리 #성수동분위기좋은카페 #성수동데\n이트 #성수동핫플 #서울숲핫플레이스"
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


// MARK: View
extension HashtagResultView {
    private func resultView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ContentArea {
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("주문하신 해시태그가 나왔어요")
                            .font(.title1())
                            .foregroundColor(.black)
                        
                        Text("생성된 해시태그가 마음에 들지 않는다면\n재생성 버튼을 통해 새로운 해시태그를 생성해 보세요.")
                            .font(.body2Bold())
                            .foregroundColor(Color.gray4)
                        
                    }
                    
                    VStack(alignment: .trailing, spacing: 20) {
                        hashtagRectangle(hashTags: "#서울카페 #서울숲카페 #서울숲브런치맛집 #성\n수동휘낭시에 #성수동여행 #서울숲카페탐방 #성\n수동디저트 #성수동감성카페 #서울신상카페 #서\n울숲카페거리 #성수동분위기좋은카페 #성수동데\n이트 #성수동핫플 #서울숲핫플레이스")
                    }
                }
            }
            Spacer()
            
            //MARK: 완료 / 재생성 버튼
            CustomDoubleeBtn(leftBtnLabel: "완료", rightBtnLabel: "재생성", leftAction: {
                pathManager.path.removeAll()
            }, rightAction: {
                //TODO: 해시태그 재생성 기능 추가해주세요!
            })
            
        }
        .toast(isShowing: $isShowingToast)
    }
    
    private func hashtagRectangle(hashTags: String) -> some View {
        RoundedRectangle(cornerRadius: radius1)
            .foregroundColor(Color.gray1)
            .frame(height: 161)
            .overlay {
                Text(hashTags)
                    .font(.body1Bold())
                    .foregroundColor(Color.gray5)
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
    }
}


//MARK: Function
extension HashtagResultView {
    // MARK: 카피 복사
    // TODO: 실제로 결과값이 생기면 복사해야합니다.
    private func copyToClipboard() {
        pasteBoard.string = dummidata
        isShowingToast = true
    }
}

#Preview {
    HashtagResultView()
}