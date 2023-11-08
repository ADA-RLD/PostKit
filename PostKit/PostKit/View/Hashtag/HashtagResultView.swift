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
    @State private var copyId = UUID()
    @State private var showAlert: Bool = false
    @State private var showModal = false
    @State private var isCaptionChange = false
    @State private var activeAlert: ActiveAlert = .second
    @ObservedObject var coinManager = CoinManager.shared
    @EnvironmentObject var pathManager: PathManager
    
    //Create Hashtag
    private let hashtagService = HashtagService()
    
    @ObservedObject var viewModel = HashtagViewModel.shared
    @ObservedObject var loadingModel = LoadingViewModel.shared
    
    private let pasteBoard = UIPasteboard.general
    
    //CoreData Manager
    let coreDataManager = CoreDataManager.instance
    
    var body: some View {
        ZStack {
            resultView()
                .onAppear{
                    checkDate()
                }
            if showAlert == true {
                switch activeAlert {
                case .first:
                    CustomAlertMessageDouble(alertTopTitle: "재생성 할까요?", alertContent: "1 크레딧이 사용돼요 \n남은 크레딧 : \(coinManager.coin)", topBtnLabel: "확인", bottomBtnLabel: "취소", topAction: {if coinManager.coin > CoinManager.minimalCoin {
                        loadingModel.isCaptionGenerate = false
                        pathManager.path.append(.Loading)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                            coinManager.coinHashtagUse()
                            pathManager.path.append(.HashtagResult)
                        }
                        viewModel.hashtag = hashtagService.createHashtag(locationArr: viewModel.locationKey, emphasizeArr: viewModel.emphasizeKey)
                    }
                        showAlert = false
    }, bottomAction: {showAlert = false}, showAlert: $showAlert)
                case .second:
                    CustomAlertMessage(alertTopTitle: "크레딧을 모두 사용했어요", alertContent: "크레딧이 있어야 재생성할 수 있어요", topBtnLabel: "확인", topAction: {showAlert = false})
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toast(toastText: "클립보드에 복사했어요", toastImgRes: Image(.copy), isShowing: $isShowingToast)
    }
}

extension HashtagResultView {
    func checkDate() {
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy.MM.dd"
        let currentDay = formatterDate.string(from: Date())
        
        if currentDay != coinManager.date {
            coinManager.date = currentDay
            coinManager.coin = CoinManager.maximalCoin
            print("코인이 초기화 되었습니다.")
        }
    }
}

// MARK: View
extension HashtagResultView {
    private func resultView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ContentArea {
                VStack(alignment: .leading, spacing: 40.5) {
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            if isCaptionChange {
                                saveEditHashtagResult(_uuid: copyId, _result: viewModel.hashtag, _like: isLike)
                            }
                            loadingModel.inputArray.removeAll()
                            pathManager.path.removeAll()
                        }, label: {
                            Text("완료")
                                .body1Bold(textColor: .gray5)
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        
                        HStack {
                            Text("주문하신 해시태그가 나왔어요!")
                                .title1(textColor: .gray6)
                            Spacer()
                            Image(.pen)
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundColor(.gray4)
                                .onTapGesture {
                                    self.showModal = true
                                }
                        }.sheet(isPresented: self.$showModal, content: {
                            ResultUpdateModalView(
                                showModal: $showModal, isChange: $isCaptionChange,
                                stringContent: $viewModel.hashtag,
                                resultUpdateType: .hashtagResult
                            ) { updatedText in
                                viewModel.hashtag = updatedText
                            }
                            .interactiveDismissDisabled()
                        })
                        .onChange(of: viewModel.hashtag){ _ in
                            // LocationTag와 Keyword는 확장성을 위해 만들어 두었습니다.
                            //isLike 변수는 좋아요 입니다.
                            copyId = saveHashtagResult(date: convertDayTime(time: Date()), locationTag: viewModel.locationKey, keyword: viewModel.emphasizeKey, result: viewModel.hashtag, isLike: isLike)
                        }
                        
                        VStack(spacing: 4) {
                            Text(viewModel.hashtag)
                                .body1Regular(textColor: .gray5)
                            
                            HStack {
                                Spacer()
                                //TODO: 좋아요 기능 추가
                                Image(.heart)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.gray3)
                            }
                        }
                        .padding(EdgeInsets(top: 24, leading: 20, bottom: 24, trailing: 20))
                        .clipShape(RoundedRectangle(cornerRadius: radius1))
                        .foregroundColor(.clear)
                        .overlay {
                            RoundedRectangle(cornerRadius: radius1)
                                .stroke(Color.gray2, lineWidth: 1)
                        }
                    }
                }
            }
            Spacer()
            
            //MARK: 재생성 / 복사 버튼
            CustomDoubleBtn(leftBtnLabel: "재생성", rightBtnLabel: "복사") {
                showAlert = true
                if coinManager.coin > 0 {
                    activeAlert = .first
                }
                else {
                    activeAlert = .second
                }
            } rightAction: {
                copyToClipboard()
            }
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
    
    func fetchHashtag() {
        //여기서는 fetch하지 않아요
    }
    
    func saveHashtagResult(date: Date, locationTag: Array<String>, keyword: Array<String>, result: String, isLike: Bool) -> UUID{
        let newHashtag = HashtagData(context: coreDataManager.context)
        newHashtag.resultId = UUID()
        newHashtag.date = date
        newHashtag.hashtag = result
        newHashtag.like = isLike
        coreDataManager.save()
        
        return newHashtag.resultId ?? UUID()
        
        print("Hashtag 저장 완료!\n resultId : \(newHashtag.resultId)\n Date : \(newHashtag.date)\n Hashtag : \(newHashtag.hashtag)\n")
    }
    
    func saveEditHashtagResult(_uuid: UUID, _result: String, _like: Bool) {
        //생성중
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
