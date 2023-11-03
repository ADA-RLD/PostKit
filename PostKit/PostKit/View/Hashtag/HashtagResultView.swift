//
//  HashtagResultView.swift
//  PostKit
//
//  Created by 김다빈 on 10/30/23.
//

import SwiftUI
import CoreData

struct HashtagResultView: View {
 
    @State private var isShowingToast = false
    @State private var isLike = false //좋아요 버튼은 결과뷰에서만 존재합니다
    @EnvironmentObject var pathManager: PathManager
    
    //Create Hashtag
    private let hashtagService = HashtagService()
    
    @ObservedObject var viewModel = HashtagViewModel.shared

    private let pasteBoard = UIPasteboard.general
    
    //CoreData Manager
    let coreDataManager = CoreDataManager.instance
    
    var body: some View {
        resultView()
            .navigationBarBackButtonHidden()
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
                        hashtagRectangle(hashTags: "\(viewModel.hashtag)")
                    }
                    .onChange(of: viewModel.hashtag){ _ in
                        // LocationTag와 Keyword는 확장성을 위해 만들어 두었습니다.
                        //isLike 변수는 좋아요 입니다.
                        SaveHashtag(date: convertDayTime(time: Date()), locationTag: viewModel.locationKey, keyword: viewModel.emphasizeKey, result: viewModel.hashtag, isLike: isLike)
                    }
                }
            }
            Spacer()
            
            //MARK: 완료 / 재생성 버튼
            CustomDoubleBtn(leftBtnLabel: "완료", rightBtnLabel: "재생성", leftAction: {
                pathManager.path.removeAll()
            }, rightAction: {
                viewModel.hashtag = hashtagService.createHashtag(locationArr: viewModel.locationKey, emphasizeArr: viewModel.emphasizeKey)
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
                    .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
            }
          
    }
}

extension HashtagResultView : HashtagProtocol {
    func convertDayTime(time: Date) -> Date {
        let today = Date()
        let timezone = TimeZone.autoupdatingCurrent
        let secondsFromGMT = timezone.secondsFromGMT(for: today)
        let localizedDate = today.addingTimeInterval(TimeInterval(secondsFromGMT))
        return localizedDate
    }
    
    func FetchHashtag() {
        //여기서는 fetch하지 않아요
    }
    
    func SaveHashtag(date: Date, locationTag: Array<String>, keyword: Array<String>, result: String, isLike: Bool) {
        let newHashtag = HashtagData(context: coreDataManager.context)
        newHashtag.resultId = UUID()
        newHashtag.date = date
        newHashtag.hashtag = result
        newHashtag.like = isLike
        coreDataManager.save()
        
        print("Hashtag 저장 완료!\n resultId : \(newHashtag.resultId)\n Date : \(newHashtag.date)\n Hashtag : \(newHashtag.hashtag)\n")
    }
    
    
}

//MARK: Function
extension HashtagResultView {
    // MARK: 카피 복사
    private func copyToClipboard() {
        pasteBoard.string = viewModel.hashtag
        isShowingToast = true
    }
}

#Preview {
    HashtagResultView()
}
