//
//  HashtagView.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/28.
//

import SwiftUI
import CoreData

struct HashtagView: View {
    @EnvironmentObject var pathManager: PathManager
    @State private var locationText = ""
    @State private var emphasizeText = ""
    @State private var locationTags: [String] = []
    @State private var emphasizeTags: [String] = []
    @State private var isActive = false
    @State private var isShowingDescription = false
    @State private var showingAlert = false
    @State private var showCreditAlert = false
    @State private var popupState: PopoverType = .keyword
    @State private var headerHeight: CGFloat = 0
    @State private var titleHeight: CGFloat = 0
    @State private var regionAreaHeight: CGFloat = 0
    @State private var keywordLimit = 4
    
    @ObservedObject var coinManager = CoinManager.shared
    @ObservedObject var viewModel = HashtagViewModel.shared
    
    //Create Hashtag
    private let hashtagService = HashtagService()
    
    //CoreData Manager
    private let coreDataManager = CoreDataManager.instance
    
    //CoreData Class
    @State private var hashtags: [HashtagModel] = []
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                CustomHeader(action: {pathManager.path.removeLast()}, title: "해시태그 생성")
                    .readSize { size in
                        headerHeight = size.height
                    }
                
                ScrollView {
                    ContentArea {
                        VStack(alignment: .leading, spacing: 40) {
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(spacing: 12.0) {
                                    HStack {
                                        HStack {
                                            Text("지역명")
                                                .body1Bold(textColor: .gray5)
                                            Text("\(locationTags.count)/5")
                                                .body2Bold(textColor: .gray4)
                                        }
                                        Spacer()
                                        Image(.info)
                                            .foregroundColor(.gray3)
                                            .onTapGesture(count:1, coordinateSpace: .global) { location in
                                                handlePopoverClick(clickType: .region)
                                            }
                                    }
                                    
                                    ZStack(alignment: .topLeading) {
                                        CustomTextfield(text: $locationText, placeHolder: "한남동", customTextfieldState: .reuse) {
                                            if !locationText.isEmpty && locationTags.count <= keywordLimit {
                                                locationTags.append(locationText)
                                                checkTags()
                                            } else if locationTags.count > keywordLimit {
                                                showingAlert = true
                                            }
                                        }
                                        .alert(isPresented: $showingAlert) {
                                            Alert(title: Text(""), message: Text("최대 5개까지만 입력할 수 있습니다."),
                                                  dismissButton: .default(Text("확인")))
                                        }
                                    }
                                }
                                
                                WrappingHStack(alignment: .leading) {
                                    ForEach(locationTags, id: \.self) { tag in
                                        CustomHashtag(tagText: tag) {
                                            locationTags.removeAll(where: { $0 == tag })
                                            checkTags()
                                        }
                                    }
                                }
                            }
                            .readSize { size in
                                regionAreaHeight = size.height
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(spacing: 12.0) {
                                    HStack {
                                        HStack(spacing: 8.0) {
                                            Text("강조 키워드")
                                                .body1Bold(textColor: .gray5)
                                            Text("\(emphasizeTags.count)/5")
                                                .body2Bold(textColor: .gray4)
                                            Text("선택")
                                                .body2Bold(textColor: .gray3)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(.info)
                                            .foregroundColor(.gray3)
                                            .onTapGesture(count:1, coordinateSpace: .global) { location in
                                                handlePopoverClick( clickType: .keyword)
                                            }
                                    }
                                    
                                    ZStack(alignment: .topLeading) {
                                        CustomTextfield(text: $emphasizeText, placeHolder: "마카롱", customTextfieldState: .reuse) {
                                            if !emphasizeText.isEmpty && emphasizeTags.count <= keywordLimit {
                                                emphasizeTags.append(emphasizeText)
                                            } else if emphasizeTags.count > keywordLimit {
                                                showingAlert = true
                                            }
                                        }
                                        .alert(isPresented: $showingAlert) {
                                            Alert(title: Text(""), message: Text("최대 5개까지만 입력할 수 있습니다."),
                                                  dismissButton: .default(Text("확인")))
                                        }
                                    }
                                }
                                
                                WrappingHStack(alignment: .leading) {
                                    ForEach(emphasizeTags, id: \.self) { tag in
                                        CustomHashtag(tagText: tag) {
                                            emphasizeTags.removeAll(where: { $0 == tag })
                                        }
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                Spacer()
                CTABtn(btnLabel: "해시태그 생성", isActive: self.$isActive, action: {
                    if coinManager.coin > CoinManager.minimalCoin {
                        pathManager.path.append(.HashtagResult)
                        Task{
                            viewModel.emphasizeKey = emphasizeTags
                            viewModel.locationKey = locationTags
                            viewModel.hashtag = hashtagService.createHashtag(locationArr: locationTags, emphasizeArr: emphasizeTags)
                            
                            //해쉬태드 생성시 기본 좋아요는 false로 가져갑니다.
                            saveHashtagResult(date: convertDayTime(time: Date()), locationTag: viewModel.locationKey, keyword: viewModel.emphasizeKey, result: viewModel.hashtag, isLike: false)
                            
                            print(hashtagService.createHashtag(locationArr: locationTags, emphasizeArr: emphasizeTags))
                            
                            pathManager.path.append(.Loading)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                                coinManager.coinHashtagUse()
                            }
                        }
                    }
                    else {
                        showCreditAlert = true
                    }
                })
            }
            
            if isShowingDescription {
                popoverView(popupState)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .background(Color.gray5.opacity(0.4))
                    .zIndex(1)
            }
            if showCreditAlert {
                CustomAlertMessage(alertTopTitle: "크레딧을 모두 사용했어요", alertContent: "크레딧이 있어야 생성할 수 있어요\n크레딧은 정각에 충전돼요", topBtnLabel: "확인") {pathManager.path.removeAll()}
                }
        }
        .onAppear{fetchHashtag()}
        .navigationBarBackButtonHidden()
    }
}

//MARK: extension: HashtagView Functions
extension HashtagView {
    private func handlePopoverClick(clickType: PopoverType) {
        popupState = clickType
        withAnimation(.easeInOut){
            isShowingDescription.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut) {
                isShowingDescription = false
            }
        }
    }
    
    private func checkTags() {
        if !locationTags.isEmpty {
            isActive = true
        } else {
            isActive = false
        }
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
}

//MARK: extension: HashtagView Views
extension HashtagView {
    
    @ViewBuilder
    func popoverView(_ type: PopoverType) -> some View {
        VStack {
            HStack {
                Spacer()
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        TriangleView()
                            .foregroundColor(.gray1)
                            .frame(width: 18, height: 12)
                            .offset(x: 10, y: 3)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: radius1)
                            .frame(width: 200, height: 167)
                            .foregroundColor(.gray1)
                        
                        VStack(alignment: .leading) {
                            switch type {
                            case .region:
                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(0..<type.description.count, id: \.self) { index in
                                        Text(type.description[index])
                                            .foregroundColor(index % 2 == 1 ? .gray4 : .gray5)
                                            .font(.body2Bold())
                                    }
                                }
                            case .keyword:
                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(0..<type.description.count, id: \.self) { index in
                                        Text(type.description[index])
                                            .foregroundColor(index % 2 == 1 ? .gray4 : .gray5)
                                            .font(.body2Bold())
                                            .lineSpacing(6)
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: 166, height: 119)
                .offset(x: 4, y: type == .region ? headerHeight + titleHeight + 96 : headerHeight + titleHeight + regionAreaHeight + 124 )
            }
            .zIndex(2)
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

extension HashtagView : HashtagProtocol {
    
    func convertDayTime(time: Date) -> Date {
        let today = Date()
        let timezone = TimeZone.autoupdatingCurrent
        let secondsFromGMT = timezone.secondsFromGMT(for: today)
        let localizedDate = today.addingTimeInterval(TimeInterval(secondsFromGMT))
        return localizedDate
    }
    
    func fetchHashtag() {
        let HashtagRequest = NSFetchRequest<HashtagData>(entityName: "HashtagData")
        
        do {
            let hashtagDataArray = try coreDataManager.context.fetch(HashtagRequest)
            hashtags = hashtagDataArray.map{ hashtagCoreData in
                return HashtagModel(
                    _id: hashtagCoreData.resultId ?? UUID(),
                    _date: hashtagCoreData.date ?? Date(),
                    _locationTag: hashtagCoreData.locationTag ?? [""],
                    _keyword: hashtagCoreData.keyword ?? [""],
                    _hashtag: hashtagCoreData.hashtag ?? "",
                    _isLike: false
                )
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
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
        //여기서는 수정이 필요하지 않아요.
    }
}

#Preview {
    HashtagView()
}
