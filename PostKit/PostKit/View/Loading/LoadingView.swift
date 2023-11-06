//
//  SwiftUIView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/14.
//

import SwiftUI

struct LoadingView: View {
    
    @State var count: Int = 0
    @State var timeStap: Int = 0
    
    @ObservedObject var loadingModel = LoadingViewModel.shared
    
    var body: some View {
        
        let Tips: [TipStruck] = [
             TipStruck(tipNum: 0, tipTitle: "􀛮 방문자 수를 높이는 프로필 셋팅", tips: "호기심을 자극하는 프로필 사진을 설정하세요\n계정의 주목도를 높여주는 스토리를 활용하세요\n검색에 잘 걸리는 프로필 이름을 사용하세요"),
             TipStruck(tipNum: 1, tipTitle: "􀛮 주목도를 높이는 인스타그램 스토리", tips: "스토리를 업로드할 경우 프로필 사진에 띠가 생겨요 24시간동안만 유지되어 부담없이 업로드할 수 있고,스토리가 없을 때보다 프로필이 눈에 띄어요!"),
             TipStruck(tipNum: 2, tipTitle: "􀛮 스토리에 올릴 콘텐츠 추천", tips: "현재 상황을 생동감 넘치는 영상으로 찍어 올려보세요\n고객의 후기를 공유해보세요\n내 피드 게시물을 다시 공유해보세요"),
             TipStruck(tipNum: 3, tipTitle: "􀛮 유입을 높이는 프로필 이름 만들기", tips: "강조하고 싶은 유입 키워드와 매장 이름의 조합으로 프로필 이름을 만들어보세요!\n계정태그와 해시태그를 적절히 활용하세요"),
             TipStruck(tipNum: 4, tipTitle: "􀛮 스토리 하이라이트 기능", tips: "업로드한 스토리를 24시간 후에도 고정시켜 노출할 수 있는 방법이 있어요! 하이라이트를 활용해 스토리를 카테고리화하여 어필하세요")
         ]
        
        VStack (alignment: .leading){
            //top back button
            HStack (alignment: .top){
                Image(systemName: "chevron.backward")
                    .font(.title2)
                    .padding(16)
                
                Spacer()
            }       
            
            ContentArea {
                
                Text("글을 만들고 있어요!")
                    .font(.title2)
                
                Text("지금 서비스를 나가면 생성이 중단돼요.\n잠시만 기다려 주세요!")
                    .font(.caption)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Image("onboarding_start_image")
            
                LoadingTipView(_timeStep: timeStap, tips: Tips)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.count = count + 1
                timeStap = count % 5
                
                if loadingModel.isCaptionGenerate {
                    timer.invalidate()
                    print("\nCaption 생성시간 : \(count)초\n")
                }
            }
        }
    }
}

struct TipStruck {
    let tipNum: Int
    let tipTitle: String
    let tips: String
}

private func LoadingTipView(_timeStep: Int, tips: [TipStruck]) -> some View {
    
    return ZStack {
        Rectangle()
            .frame(width: 335, height: 147)
            .foregroundColor(.sub)
            .cornerRadius(12)

        VStack(alignment: .leading, spacing: 12) {
            Text(tips[_timeStep].tipTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
           

            Text(tips[_timeStep].tips)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(24)
    }
}


#Preview {
    LoadingView()
}
