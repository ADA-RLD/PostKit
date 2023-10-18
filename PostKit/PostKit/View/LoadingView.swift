//
//  SwiftUIView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/14.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .controlSize(.large)
                .padding(.bottom, 40)
            Text("카피가 만들어지고 있어요")
                .font(.title1())
                .foregroundStyle(Color.gray6)
                .padding(.bottom, 12)
            Text("30초 가량 소요될 수 있어요.")
                .font(.body2Bold())
                .foregroundStyle(Color.gray4)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LoadingView()
}
