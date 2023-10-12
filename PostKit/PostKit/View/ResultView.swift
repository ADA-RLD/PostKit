//
//  ResultView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI
import UIKit

struct ResultView: View {
    
    @State private var copyResult = "구름이 가득한 하늘이 내 기분과 딱 맞아!"
    private let pasteBoard = UIPasteboard.general
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - 타이틀과 설명
                VStack(alignment: .leading, spacing: 12) {
                    Text("주문하신 카피가 나왔어요!")
                        .font(.title1())
                        .foregroundStyle(Color.gray6)
                    Text("생성된 피드가 마음에 들지 않는다면\n다시 생성하기 버튼을 통해 새로운 피드를 생성해 보세요.")
                        .font(.body2Bold())
                        .foregroundStyle(Color.gray4)
                }
                
                // MARK: - 생성된 카피 출력 + 복사하기 버튼
                VStack(alignment: .trailing, spacing: 20) {
                    VStack(alignment: .leading) {
                        Text(copyResult)
                            .multilineTextAlignment(.leading)
                            .font(.body1Bold())
                            .foregroundStyle(Color.gray5)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 400)
                    .background(Color.gray1)
                    .cornerRadius(radius2)
                    
                    Button {
                        copyToClipboard()
                    } label: {
                        HStack(spacing: 4.0) {
                            Image(systemName: "doc.on.doc")
                            Text("복사하기")
                        }
                        .foregroundStyle(Color.main)
                        .font(.body1Bold())
                    }
                }
            }
            Spacer()
            
            // MARK: - 완료 / 재생성 버튼
            CustomDoubleeBtn(leftBtnDescription: "완료", rightBtnDescription: "재생성") {
                // TODO: 메인으로
            } rightAction: {
                // TODO: 카피 재생성 기능
            }
            .padding(.vertical, 12)
            
        }
        .padding(.horizontal, paddingHorizontal)
    }
    
    func copyToClipboard() {
        pasteBoard.string = copyResult
    }
}

#Preview {
    ResultView()
}
