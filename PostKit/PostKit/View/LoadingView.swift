//
//  SwiftUIView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/14.
//

import SwiftUI
import Mixpanel

struct LoadingView: View {
    @EnvironmentObject var pathManager: PathManager
    
    var body: some View {
        VStack {
            ProgressView()
                .controlSize(.large)
                .padding(.bottom, 40)
            Text("카피가 만들어지고 있어요")
                .title1(textColor: .gray6)
                .padding(.bottom, 12)
            Text("30초 가량 소요될 수 있어요.")
                .body2Bold(textColor: .gray4)
        }
        .onAppear {
            if pathManager.path.contains(.Daily) {
                Mixpanel.mainInstance().time(event: "일상 글 로딩")
            }
            else if pathManager.path.contains(.Menu) {
                Mixpanel.mainInstance().time(event: "메뉴 글 로딩")
            }
            else if pathManager.path.contains(.Hashtag) {
                Mixpanel.mainInstance().time(event: "해시태그 글 로딩")
            }
            
        }
        .onDisappear {
            if pathManager.path.contains(.Daily) {
                Mixpanel.mainInstance().track(event: "일상 글 로딩")
            }
            else if pathManager.path.contains(.Menu) {
                Mixpanel.mainInstance().track(event: "메뉴 글 로딩")
            }
            else if pathManager.path.contains(.Hashtag) {
                Mixpanel.mainInstance().track(event: "해시태그 글 로딩")
            }
            
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LoadingView()
}
