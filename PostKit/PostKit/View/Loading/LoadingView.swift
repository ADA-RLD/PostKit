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
    @State var count: Int = 0
    @State var tagTimeStep: Int = 0
    @State var timeStep: Int = 0
    @State private var isActiveAlert: Bool = false
    
    //디버깅용 데이터 삭제하지는 말아주세요.
    //private var SampleData: [String] = ["1번 친구","2번 친구","3번 친구","4번 친구","5번 친구"]
    @ObservedObject var loadingModel = LoadingViewModel.shared
    @ObservedObject var chatGpt = ChatGptService.shared
    
    var body: some View {
        
        let Tips: [TipStruck] = [
            TipStruck(tipNum: 0, tipTitle: "방문자 수를 높이는 프로필 셋팅", tips: "호기심을 자극하는 프로필 사진을 설정하세요\n계정의 주목도를 높여주는 스토리를 활용하세요\n검색에 잘 걸리는 프로필 이름을 사용하세요"),
            TipStruck(tipNum: 1, tipTitle: "주목도를 높이는 인스타그램 스토리", tips: "스토리를 업로드할 경우 프로필 사진에 띠가 생겨요 24시간동안만 유지되어 부담없이 업로드할 수 있고,스토리가 없을 때보다 프로필이 눈에 띄어요!"),
            TipStruck(tipNum: 2, tipTitle: "스토리에 올릴 콘텐츠 추천", tips: "현재 상황을 생동감 넘치는 영상으로 찍어 올려보세요\n고객의 후기를 공유해보세요\n내 피드 게시물을 다시 공유해보세요"),
            TipStruck(tipNum: 3, tipTitle: "유입을 높이는 프로필 이름 만들기", tips: "강조하고 싶은 유입 키워드와 매장 이름의 조합으로 프로필 이름을 만들어보세요!\n계정태그와 해시태그를 적절히 활용하세요"),
            TipStruck(tipNum: 4, tipTitle: "스토리 하이라이트 기능", tips: "업로드한 스토리를 24시간 후에도 고정시켜 노출할 수 있는 방법이 있어요! 하이라이트를 활용해 스토리를 카테고리화하여 어필하세요")
        ]
        ZStack {
            VStack(spacing: 0){
                CustomHeader(
                    action: {
                        isActiveAlert = true
                    },
                    title: ""
                )
                
                VStack {
                    HStack{
                        VStack(alignment: .leading, spacing: 12){
                            Text("글을 만들고 있어요!")
                                .title1(textColor: .gray6)
                            
                            Text("지금 서비스를 나가면 생성이 중단돼요.\n최대 30초가 소요될 예정이에요.")
                                .body1Bold(textColor: .gray4)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    LoadingImageFunc(inputArr: loadingModel.inputArray, timeStep: tagTimeStep)
                    
                    LoadingTipView(_timeStep: timeStep, tips: Tips)
                        .frame(height: 150)
                        .padding(.bottom, 12)
                }
                .padding(.horizontal, 20)
                .padding(.top, 27.6)
                .frame(width: UIScreen.main.bounds.width)
            }
            
            if isActiveAlert == true {
                CustomAlertMessageDouble(
                    alertTopTitle: "생성을 취소할까요?",
                    alertContent: "취소하더라도 1 크레딧이 사용돼요",
                    topBtnLabel: "생성 취소",
                    bottomBtnLabel: "계속 생성",
                    topAction:{
                        chatGpt.isCanceled = true
                        pathManager.path.removeLast()
                        trackingCancel()
                    },
                    bottomAction: {
                        self.isActiveAlert = false
                    },
                    showAlert: $isActiveAlert)
            }
        }
        
        .navigationBarBackButtonHidden()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { timer in
                self.count = count + 1
                timeStep = count % 5
            }
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { hashTagTimer in
                self.count = count + 1
                if loadingModel.inputArray.count != 0{
                    tagTimeStep = count % (loadingModel.inputArray.count + 1)
                }else {
                    tagTimeStep = 0
                }
                
                
                if loadingModel.isCaptionGenerate {
                    hashTagTimer.invalidate()
                    print("\nCaption 생성시간 : \(count)초\n")
                }
            }
            Mixpanel.mainInstance().time(event: "글 로딩")
        }
        .onDisappear {
            if pathManager.path.contains(.Daily) {
                Mixpanel.mainInstance().track(event: "글 로딩", properties: ["카테고리": "일상"])
            }
            else if pathManager.path.contains(.Menu) {
                Mixpanel.mainInstance().track(event: "글 로딩", properties: ["카테고리": "메뉴"])
            }
            else if pathManager.path.contains(.Hashtag) {
                Mixpanel.mainInstance().track(event: "글 로딩", properties: ["카테고리": "해시태그"])
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
            .frame(maxWidth: .infinity)
            .foregroundColor(.sub)
            .cornerRadius(12)
        
        VStack(alignment: .leading, spacing: 12) {
            HStack{
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text(tips[_timeStep].tipTitle)
                    .body1Bold(textColor: .gray5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text(tips[_timeStep].tips)
                .body2Regular(textColor: .gray4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(24)
    }
}

private func LoadingImageFunc(inputArr: Array<String>, timeStep: Int) -> some View {
    
    ZStack{
        VStack (alignment: .center){
            HStack (alignment: .bottom){
                if timeStep == 0 {
                    Spacer()
                }
                if timeStep > 0 {
                    CustomTagFeild(tagText: inputArr[0]) {
                        print("Hello")
                    }
                }
                if timeStep > 2 {
                    CustomTagFeild(tagText: inputArr[2]) {
                        print("Hello")
                    }
                }
                if timeStep > 4 {
                    CustomTagFeild(tagText: inputArr[4]) {
                        print("Hello")
                    }
                    
                }
                Spacer()
            }
            .frame(width: 500)
            .frame(maxHeight: .infinity)
            .offset(x: 200, y: -20)
            
            HStack{
                if timeStep > 1 {
                    CustomTagFeild(tagText: inputArr[1]) {
                        print("Hello")
                    }
                    .offset(x: 110, y: -20)
                    .rotationEffect(.degrees(5))
                }
            }
            .frame(maxHeight: .infinity)
            
            HStack{
                if timeStep > 3 {
                    CustomTagFeild(tagText: inputArr[3]) {
                        print("Hello")
                    }
                    .offset(x: 110, y: -110)
                    .rotationEffect(.degrees(-8))
                }else {
                    Spacer()
                        .frame(height: 32)
                }
            }
        }
        Image("loading_image")
            .frame(maxHeight: .infinity)
    }
}

private extension LoadingView {
    private func trackingCancel() {
        if pathManager.path.contains(.Daily) {
            Mixpanel.mainInstance().track(event: "사용자 생성 취소", properties: ["카테고리": "일상"])
        }
        else if pathManager.path.contains(.Menu) {
            Mixpanel.mainInstance().track(event: "사용자 생성 취소", properties: ["카테고리": "메뉴"])
        }
        else if pathManager.path.contains(.Hashtag) {
            Mixpanel.mainInstance().track(event: "사용자 생성 취소", properties: ["카테고리": "해시태그"])
        }
    }
}
struct CustomTagFeild: View {
    let tagText: String
    let deleteAction: () -> Void
    
    var body: some View {
        HStack {
            Text(tagText)
                .body2Regular(textColor: .main)
        }
        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        .background(Color.sub)
        .clipShape(RoundedRectangle(cornerRadius: radius1))
        .overlay {
            RoundedRectangle(cornerRadius: radius1)
                .stroke(Color.main, lineWidth: 2)
        }
    }
}


#Preview {
    LoadingView()
}

