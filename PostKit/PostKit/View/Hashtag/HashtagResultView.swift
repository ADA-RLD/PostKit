//
//  HashtagResultView.swift
//  PostKit
//
//  Created by 김다빈 on 10/30/23.
//

import SwiftUI
import CoreData
import Mixpanel

struct HashtagResultView: View {
    
    @State private var isShowingToast = false
    @State private var isLike = false //좋아요 버튼은 결과뷰에서만 존재합니다
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
    @ObservedObject var chatGpt = APIManager.shared
    
    private let pasteBoard = UIPasteboard.general
    private let copyManager = CopyManger.instance
    
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
                    CustomAlertMessageDouble(
                        alertTopTitle: "재생성 할까요?",
                        alertContent: "1 크레딧이 사용돼요 \n남은 크레딧 : \(coinManager.coin)",
                        topBtnLabel: "확인",
                        bottomBtnLabel: "취소",
                        topAction: {
//                            if coinManager.coin > CoinManager.minimalCoin {
//                                loadingModel.isCaptionGenerate = false
//                                pathManager.path.append(.Loading)
//                                Mixpanel.mainInstance().track(event: "재생성", properties: ["카테고리": "해시태그"])
//                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//                                    $coinManager.coinHashtagUse()
//                                    if !chatGpt.isCanceled {
//                                        pathManager.path.append(.HashtagResult)
//                                        viewModel.hashtag = hashtagService.createHashtag(locationArr: viewModel.locationKey, emphasizeArr: viewModel.emphasizeKey)
//                                    }
//                                    else{
//                                        chatGpt.isCanceled = false
//                                    }
//                                }
//                            }
//                            showAlert = false
                        }, 
                        bottomAction: {
                            showAlert = false
                        },
                        showAlert: $showAlert)
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
                                saveEditHashtagResult(_uuid: viewModel.id, _result: viewModel.hashtag, _like: isLike)
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
                            )
                            .interactiveDismissDisabled()
                        })
                        
                        VStack(spacing: 4) {
                            Text(viewModel.hashtag)
                                .body1Regular(textColor: .gray5)
                            
                            HStack {
                                Spacer()
                                Image(.heart)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(isLike ? .main : .gray3)
                                    .onTapGesture {
                                        withAnimation(.easeIn(duration: 0.3)) {
                                            isLike.toggle()
                                            saveEditHashtagResult(_uuid: viewModel.id, _result: viewModel.hashtag, _like: isLike)
                                        }
                                    }
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
            CustomDoubleBtn(leftBtnLabel: "재생성하기", rightBtnLabel: "복사하기") {
                showAlert = true
                if coinManager.coin >= CoinManager.hashtagCost {
                    activeAlert = .first
                }
                else {
                    activeAlert = .second
                }
            } rightAction: {
                Mixpanel.mainInstance().track(event: "복사", properties: ["카테고리": "해시태그"])
                // TODO: 버튼 계속 클릭 시 토스트 사라지지 않는 것 FIX 해야함
                copyManager.copyToClipboard(copyString: viewModel.hashtag)
                isShowingToast = true
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
        let fetchRequest = NSFetchRequest<HashtagData>(entityName: "HashtagData")
        
        // captionModel의 UUID가 같을 경우
        let predicate = NSPredicate(format: "resultId == %@", _uuid as CVarArg)
        fetchRequest.predicate = predicate
        
        if let existingHastagResult = try? coreDataManager.context.fetch(fetchRequest).first {
            // UUID에 해당하는 데이터를 찾았을 경우 업데이트
            existingHastagResult.hashtag = _result
            existingHastagResult.like = _like
            
            coreDataManager.save() // 변경사항 저장
            
            print("Hastag 수정 완료!\n resultId : \(existingHastagResult.resultId)\n Date : \(existingHastagResult.date)\n Caption : \(existingHastagResult.hashtag)\n HastagLike : \(existingHastagResult.like)")
        } else {
            // UUID에 해당하는 데이터가 없을 경우 새로운 데이터 생성
            let newHastag = HashtagData(context: coreDataManager.context)
            newHastag.resultId = _uuid
            newHastag.hashtag = _result
            newHastag.like = _like
            
            coreDataManager.save() // 변경사항 저장
            
            print("Hastag 수정 완료!\n resultId : \(newHastag.resultId)\n Date : \(newHastag.date)\n Caption : \(newHastag.hashtag)\n HastagLike : \(newHastag.like)")
        }
    }
}

//MARK: Function
extension HashtagResultView {
    // MARK: 카피 복사
    private func copyToClipboard() {
        let hapticManager = HapticManager.instance
        hapticManager.notification(type: .success)
        pasteBoard.string = viewModel.hashtag
        isShowingToast = true
    }
}

#Preview {
    HashtagResultView()
}

