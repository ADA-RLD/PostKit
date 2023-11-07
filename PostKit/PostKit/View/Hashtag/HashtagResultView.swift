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
    @State private var isPresented: Bool = false
    @State private var showModal = false
    @State private var isCaptionChange = false
    @State private var activeAlert: ActiveAlert = .first
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
                .navigationBarBackButtonHidden()
        }
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
                VStack(alignment: .leading, spacing: 24) {

                    HStack {
                        Spacer()
                        Button(action: {
                            //TODO: 수정된 해시태그 CoreData 저장 필요
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
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("주문하신 해시태그가 나왔어요!")
                            .title1(textColor: .gray6)
                    }
                    
                    VStack {
                        ZStack(alignment: .leading) {
                            // TODO: historyLeftAction 추가
                            HistoryButton(resultText: $viewModel.hashtag, buttonText: "수정하기", historyRightAction: {
                                self.showModal = true
                            }, historyLeftAction: {}).sheet(isPresented: self.$showModal, content: {
                                ResultUpdateModalView(
                                    showModal: $showModal, isChange: $isCaptionChange,
                                    stringContent: $viewModel.hashtag,
                                    resultUpdateType: .hashtagResult
                                ) { updatedText in
                                    viewModel.hashtag = updatedText
                                }
                                .interactiveDismissDisabled()
                            })
                        }
                    }
                    .onChange(of: viewModel.hashtag){ _ in
                        // LocationTag와 Keyword는 확장성을 위해 만들어 두었습니다.
                        //isLike 변수는 좋아요 입니다.
                        copyId = saveHashtagResult(date: convertDayTime(time: Date()), locationTag: viewModel.locationKey, keyword: viewModel.emphasizeKey, result: viewModel.hashtag, isLike: isLike)
                    }
                }
            }
            Spacer()
            
            //MARK: 재생성 / 복사 버튼
            CustomDoubleBtn(leftBtnLabel: "재생성하기", rightBtnLabel: "복사하기") {
                if coinManager.coin > CoinManager.hashtagCost {
                    activeAlert = .first
                    isPresented.toggle()
                }
                else {
                    activeAlert = .second
                    isPresented.toggle()
                }
            } rightAction: {
                // TODO: 버튼 계속 클릭 시 토스트 사라지지 않는 것 FIX 해야함
                copyToClipboard()
            }
            .alert(isPresented: $isPresented) {
                switch activeAlert {
                case .first:
                    let cancelBtn = Alert.Button.default(Text("취소")) {
                        
                    }
                    let regenreateBtn = Alert.Button.default(Text("재생성")) {
                        if coinManager.coin > CoinManager.hashtagCost {
                            loadingModel.isCaptionGenerate = false
                            pathManager.path.append(.Loading)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                                coinManager.coinHashtagUse()
                                pathManager.path.append(.HashtagResult)
                            }
                            viewModel.hashtag = hashtagService.createHashtag(locationArr: viewModel.locationKey, emphasizeArr: viewModel.emphasizeKey)
                        }
                    }

                    return Alert(title: Text("1크래딧이 사용됩니다.\n재생성하시겠습니까?\n\n남은 크래딧 \(coinManager.coin)/\(CoinManager.maximalCoin)"), primaryButton: cancelBtn, secondaryButton: regenreateBtn)
                case .second:
                    return Alert(title: Text("크래딧을 모두 소모하였습니다.\n재생성이 불가능합니다."))
                }
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
