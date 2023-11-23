//
//  MyWebView.swift
//  PostKit
//
//  Created by 김다빈 on 11/17/23.
//

import SwiftUI
import WebKit

struct MyWebView: View {
    @EnvironmentObject var pathManager: PathManager
    var urlToLoad: String
    
    var body: some View {
        VStack {
            CustomHeader(action: {
                pathManager.path.removeLast()
            }, title: "문의하기")
            WebViewForCS(urlToLoad: urlToLoad)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct WebViewForCS: UIViewRepresentable {
    
    var urlToLoad: String
    //UIview 만드는 함수
    func makeUIView(context: Context) -> WKWebView {
        
        guard let url = URL(string: urlToLoad) else {
            return WKWebView()
        }
        let webview = WKWebView()
        webview.load(URLRequest(url: url))
        
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebViewForCS>) {
        
    }
}
