//
//  ResultView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI
import UIKit

struct ResultView: View {
    
    @EnvironmentObject var pathManager: PathManager
    @State private var copyResult = "생성된 텍스트가 들어가요."
    @State private var isShowingToast = false
    private let pasteBoard = UIPasteboard.general
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - 타이틀 + 설명
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
                        // TODO: 버튼 계속 클릭 시 토스트 사라지지 않는 것 FIX 해야함
                    } label: {
                        HStack(spacing: 4.0) {
                            Image(systemName: "doc.on.doc")
                            Text("복사하기")
                        }
                        .foregroundStyle(Color.main)
                        .font(.body1Bold())
                        .disabled(isShowingToast)
                    }
                }
            }
            Spacer()
            
            // MARK: - 완료 / 재생성 버튼
            CustomDoubleeBtn(leftBtnDescription: "완료", rightBtnDescription: "재생성") {
                pathManager.path.removeAll()
            } rightAction: {
                // TODO: 카피 재생성 기능
            }
            .padding(.vertical, 12)
            
        }
        .padding(.horizontal, paddingHorizontal)
        .toast(isShowing: $isShowingToast)
    }
    
    // MARK: - 카피 복사
    func copyToClipboard() {
        pasteBoard.string = copyResult
        isShowingToast = true
    }
}

// MARK: - 기존 뷰 위에 토스트를 위로 올려줌
struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let duration: TimeInterval
    func body(content: Content) -> some View {
        ZStack{
            content
            if isShowing{
                VStack{
                    Spacer()
                    Text("클립보드에 복사되었습니다!")
                        .font(.body1Bold())
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .background(.black.opacity(0.6))
                        .cornerRadius(radius1)
                        .padding(.horizontal, paddingHorizontal)
                        .padding(.bottom, 20)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()+duration){
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 토스트를 띄워주는 모디파이어 적용
extension View {
    func toast(isShowing: Binding<Bool>, duration: TimeInterval = 1.5) -> some View {
        modifier(ToastModifier(isShowing: isShowing, duration: duration))
    }
}

#Preview {
    ResultView()
}
