//
//  ErrorView.swift
//  PostKit
//
//  Created by 김다빈 on 10/28/23.
//

import SwiftUI
import Combine
import Mixpanel

enum ErrorReason {
    case networkError
    case apiError
}

struct ErrorView: View {
    @EnvironmentObject var pathManager: PathManager
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var loadingModel = LoadingViewModel.shared
    
    @State var cancellables = Set<AnyCancellable>()
    
    var errorReasonState: ErrorReason = .apiError
    var errorCasue: String
    var errorDescription: String
    var errorImage: ImageResource
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Image(errorImage)
            
            VStack(alignment: .center, spacing: 12) {
                Text(errorCasue)
                    .title1(textColor: .gray6)
                    .multilineTextAlignment(.center)
                
                Text(errorDescription)
                    .body2Bold(textColor: .gray4)
                    .multilineTextAlignment(.center)
            }
            
            AlertCustomDoubleBtn(
                topBtnLabel: "재생성",
                bottomBtnLabel: "홈으로",
                topAction: {
                    if errorReasonState == .apiError {
                        Mixpanel.mainInstance().track(event: "재생성 - API")
                    }
                    else if errorReasonState == .networkError {
                        Mixpanel.mainInstance().track(event: "재생성 - 네트워크")
                    }
                    pathManager.path.append(.Loading)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                        regenerateAnswer()
                    }
                },
                bottomAction: {pathManager.path.removeAll()})
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    //    ErrorView(errorCasue: "네트워크 연결이\n원활하지 않아요", errorDescription: "네트워크 연결을 확인해주세요", imageResource: .errorNetwork)
    ErrorView(errorCasue: "생성을\n실패했어요", errorDescription: "예기치 못한 이유로 생성에 실패했어요\n 다시 시도해주세요", errorImage: .errorFailed)
}
