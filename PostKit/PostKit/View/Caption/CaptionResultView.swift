//
//  ResultView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/12.
//

import SwiftUI
import CoreData
import UIKit
import Combine
import Mixpanel

enum ActiveAlert {
    case first, second
}

enum CaptionMode {
    case daily
    case menu
}
struct CaptionResultView: View {
    @EnvironmentObject var pathManager: PathManager
    @State private var copyId = UUID()
    @State private var likeCopy = false //좋아요 버튼 결과뷰에서 변경될 수 있으니까 여기 선언
    @State private var isCaptionChange = false
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .first
    @State private var showModal = false
    @State var isShowingToast = false
    @State var messages: [Message] = []
    @State var cancellables = Set<AnyCancellable>()
    @ObservedObject var viewModel = ChatGptViewModel.shared
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var loadingModel = LoadingViewModel.shared
    
    private let pasteBoard = UIPasteboard.general
    private let chatGptService = ChatGptService()
    private let hapticManger = HapticManager.instance
    private let copyManager = CopyManger.instance
    
    var captionMode: CaptionMode = .daily
    
    //CoreData Manager
    let coreDataManager = CoreDataManager.instance
    
    //CoreData Data Class
    @StateObject var storeModel : StoreModel
    
    var body: some View {
        ZStack{
            captionResult
                .onAppear {
                    checkDate()
                    //Caption이 생성되면 바로 CoreData에 저장
                    //수정을 위해 UUID를 저장
                    copyId = saveCaptionResult(category: viewModel.category, date: convertDayTime(time: Date()), result: viewModel.promptAnswer,like: likeCopy)
                    loadingModel.isCaptionGenerate = true
                    trackingResult()
                }
                .onDisappear {
                    AppState.shared.swipeEnabled = true
                }
            if showAlert == true {
                switch activeAlert {
                case .first:
                    CustomAlertMessageDouble(alertTopTitle: "재생성 할까요?", alertContent: "2 크레딧이 사용돼요 \n남은 크레딧 : \(coinManager.coin)", topBtnLabel: "확인", bottomBtnLabel: "취소", topAction: { if coinManager.coin > CoinManager.minimalCoin {
                        loadingModel.isCaptionGenerate = false
                        pathManager.path.append(.Loading)
                        Mixpanel.mainInstance().track(event: "결과 재생성")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
                            regenerateAnswer()
                        }
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

//MARK: 가독성을 위해 View를 분리했습니다.
extension CaptionResultView {
    private var captionResult: some View {
        VStack(alignment:.leading, spacing:0) {
            ContentArea {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Spacer()
                        Button(action: {
                            if isCaptionChange {
                                saveEditCaptionResult(_uuid: copyId, _result: viewModel.promptAnswer, _like: likeCopy)
                            }
                            pathManager.path.removeAll()
                        }, label: {
                            Text("완료")
                                .body1Bold(textColor: .gray5)
                        })
                    }
                    .padding(.vertical, 20.5)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("주문하신 글이 나왔어요!")
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
                                stringContent: $viewModel.promptAnswer,
                                resultUpdateType: .captionResult
                            )
                            .interactiveDismissDisabled()
                        })
                        
                        VStack(spacing: 4) {
                            Text(viewModel.promptAnswer)
                                .body1Regular(textColor: .gray5)
                            HStack {
                                Spacer()
                                //TODO: 좋아요 기능 추가
                                Image(.heart)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(likeCopy ? .main : .gray3)
                                    .onTapGesture {
                                        withAnimation(.easeIn(duration: 0.3)) {
                                            likeCopy.toggle()
                                            saveEditCaptionResult(_uuid: copyId, _result: viewModel.promptAnswer, _like: likeCopy)
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
            
            // MARK: - 재생성 / 복사 버튼
            CustomDoubleBtn(leftBtnLabel: "재생성", rightBtnLabel: "복사") {
                showAlert = true
                // TODO: - 상수 값으로의 변경 필요
                if coinManager.coin >= CoinManager.captionCost {
                    activeAlert = .first
                }
                else {
                    activeAlert = .second
                }
            } rightAction: {
                // TODO: 버튼 계속 클릭 시 토스트 사라지지 않는 것 FIX 해야함
                copyManager.copyToClipboard(copyString: viewModel.promptAnswer)
                isShowingToast = true
                trackingCopy()
            }

        }
    }
}

// MARK: - 기존 뷰 위에 토스트를 위로 올려줌
struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    var toastImgRes: Image
    var toastText: String
    var imgColor: Color = .black
    let duration: TimeInterval
    func body(content: Content) -> some View {
        ZStack{
            content
            if isShowing{
                VStack{
                    Spacer()
                    HStack(spacing: 8) {
                        toastImgRes
                        Text(toastText)
                            .body1Bold(textColor: .white)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(.gray5)
                    .cornerRadius(radius1)
                    .padding(.horizontal, paddingHorizontal)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()+duration){
                        withAnimation(.easeOut(duration: 0.1)) {
                            isShowing = false
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 토스트를 띄워주는 모디파이어 적용
extension View {
    func toast(toastText: String, toastImgRes: Image, isShowing: Binding<Bool>, duration: TimeInterval = 2.0) -> some View {
        modifier(ToastModifier(isShowing: isShowing, toastImgRes: toastImgRes, toastText: toastText, duration: duration))
    }
}

extension CaptionResultView {
    private func trackingRegenerate() {
        if pathManager.path.contains(.Daily) {
            Mixpanel.mainInstance().track(event: "재생성", properties: ["카테고리": "일상"])
        }
        else if pathManager.path.contains(.Menu) {
            Mixpanel.mainInstance().track(event: "재생성", properties: ["카테고리": "메뉴"])
        }
    }
    
    private func trackingCopy() {
        if pathManager.path.contains(.Daily) {
            Mixpanel.mainInstance().track(event: "복사", properties: ["카테고리": "일상"])
        }
        else if pathManager.path.contains(.Menu) {
            Mixpanel.mainInstance().track(event: "복사", properties: ["카테고리": "메뉴"])
        }
    }
    
    private func trackingEdit() {
        if pathManager.path.contains(.Daily) {
            Mixpanel.mainInstance().track(event: "수정", properties: ["카테고리": "일상"])
        }
        else if pathManager.path.contains(.Menu) {
            Mixpanel.mainInstance().track(event: "수정", properties: ["카테고리": "메뉴"])
        }
    }
    
    private func trackingResult() {
        if pathManager.path.contains(.Daily) {
            Mixpanel.mainInstance().track(event: "생성 성공", properties: ["카테고리": "일상"])
        }
        else if pathManager.path.contains(.Menu) {
            Mixpanel.mainInstance().track(event: "생성 성공", properties: ["카테고리": "메뉴"])
        }
    }
}

extension CaptionResultView : CaptionResultProtocol {
    func convertDayTime(time: Date) -> Date {
        let today = Date()
        let timezone = TimeZone.autoupdatingCurrent
        let secondsFromGMT = timezone.secondsFromGMT(for: today)
        let localizedDate = today.addingTimeInterval(TimeInterval(secondsFromGMT))
        return localizedDate
    }
    
    func saveCaptionResult(category: String, date: Date, result: String, like: Bool) -> UUID {
        let newCaption = CaptionResult(context: coreDataManager.context)
        newCaption.resultId = UUID()
        newCaption.date = date
        newCaption.category = category
        newCaption.caption = result
        newCaption.like = false
        coreDataManager.save()
        print("Caption 저장 완료!\n resultId : \(newCaption.resultId)\n Date : \(newCaption.date)\n Category : \(newCaption.category)\n Caption : \(newCaption.caption)")
        
        return newCaption.resultId ?? UUID()
    }
    
    func saveEditCaptionResult(_uuid: UUID, _result: String, _like: Bool) {
        let fetchRequest = NSFetchRequest<CaptionResult>(entityName: "CaptionResult")
        
        // captionModel의 UUID가 같을 경우
        let predicate = NSPredicate(format: "resultId == %@", _uuid as CVarArg)
        fetchRequest.predicate = predicate
        
        if let existingCaptionResult = try? coreDataManager.context.fetch(fetchRequest).first {
            // UUID에 해당하는 데이터를 찾았을 경우 업데이트
            existingCaptionResult.caption = _result
            existingCaptionResult.like = _like
            
            coreDataManager.save() // 변경사항 저장
            
            print("Caption 수정 완료!\n resultId : \(existingCaptionResult.resultId)\n Date : \(existingCaptionResult.date)\n Category : \(existingCaptionResult.category)\n Caption : \(existingCaptionResult.caption)\n")
        } else {
            // UUID에 해당하는 데이터가 없을 경우 새로운 데이터 생성
            let newCaption = CaptionResult(context: coreDataManager.context)
            newCaption.resultId = _uuid
            newCaption.caption = _result
            newCaption.like = _like
            
            coreDataManager.save() // 변경사항 저장
            
            print("Caption 새로 저장 완료!\n resultId : \(_uuid)\n Date : \(newCaption.date)\n Category : \(newCaption.category)\n Caption : \(newCaption.caption)\n")
        }
    }
}

//
//#Preview {
//    CaptionResultView
//}
