//
//  ErrorView.swift
//  PostKit
//
//  Created by 김다빈 on 10/28/23.
//

import SwiftUI

struct ErrorView: View {
    
    @EnvironmentObject var pathManager: PathManager
    
    var errorCasue: String
    var errorDescription: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 80) {
            
            VStack(alignment: .center, spacing: 24) {
                
                Text(errorCasue)
                    .font(.title1())
                    .foregroundColor(.gray6)
                
                Text(errorDescription)
                    .font(.body2Bold())
                    .foregroundColor(.gray4)
                
            }
            
            VStack(alignment: .center, spacing: 16) {
                
                errorBtn(action: {
                    pathManager.path.removeAll()
                }, btnAction: "홈으로", btnColor: Color.gray2, btnTextColor: Color.gray5)
                
                errorBtn(action: {
                    //TODO: 재생성 기능 추가해야합니다.
                    print("")
                }, btnAction: "재생성", btnColor: .main, btnTextColor: .white)
                
            }
        }
        .padding(.horizontal,106)
        .navigationBarBackButtonHidden()
    }
}

// MARK: extension Views
private func errorBtn(action: @escaping () -> Void, btnAction: String, btnColor: Color, btnTextColor: Color ) -> some View {
    Button {
        action()
    } label: {
        RoundedRectangle(cornerRadius: radius1)
            .frame(height: 56)
            .overlay(alignment: .center) {
                Text(btnAction)
                    .font(.body1Bold())
                    .foregroundColor(btnTextColor)
            }
            .foregroundColor(btnColor)
    }

    
}

#Preview {
    ErrorView(errorCasue: "결과 생성 실패", errorDescription: "결과 생성에 실패했어요 ㅠ-ㅠ")
}
