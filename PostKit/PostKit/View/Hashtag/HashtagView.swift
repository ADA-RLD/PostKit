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
    @State private var isActive: Bool = false
    @State private var isShowingDescription = false
    @State private var popupState: PopOverType = .keyword
    @State private var regionPopoverOffsetFromTop: CGFloat = 0
    @State private var keywordPopoverOffsetFromTop: CGFloat = 0
    @State private var showingAlert = false
    
    @ObservedObject var viewModel = HashtagViewModel.shared
    
    //Create Hashtag
    private let hashtagService = HashtagService()
    
    //CoreData Manager
    private let coreDataManager = CoreDataManager.instance
    
    //CoreData Class
    @State private var hashtags: [HashtagModel] = []
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 0) {
                CustomHeader(action: {pathManager.path.removeLast()}, title: "해시태그 생성")
                
                ScrollView {
                    ContentArea {
                        VStack(alignment: .leading, spacing: 28) {
                            Text("입력한 지역명을 기반으로 해시태그가 생성됩니다. \n강조 키워드 미입력 시 기본 키워드만의 조합으로 생성됩니다.")
                                .font(.body2Bold())
                                .foregroundColor(.gray4)
                            
                            VStack(alignment: .leading, spacing: 28) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("지역명 *")
                                            .font(.body1Bold())
                                            .foregroundColor(.gray5)
                                        Spacer()
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.gray3)
                                            .onTapGesture(count:1, coordinateSpace: .global) { location in
                                                handlePopoverClick(location: location, clickType: .region)
                                            }
                                    }
                                    
                                    ZStack(alignment: .topLeading) {
                                        CustomTextfield(text: $locationText, placeHolder: "한남동", customTextfieldState: .reuse) {
                                            if !locationText.isEmpty && locationTags.count <= 4 {
                                                locationTags.append(locationText)
                                                checkTags()
                                            } else if locationTags.count > 4 {
                                                showingAlert = true
                                            }
                                        }
                                        .alert(isPresented: $showingAlert) {
                                            Alert(title: Text(""), message: Text("최대 5개까지만 입력할 수 있습니다."),
                                                  dismissButton: .default(Text("확인")))
                                        }
                                    }
                                    
                                    Text("최대 5개까지 작성가능합니다.")
                                        .font(.body2Regular())
                                        .foregroundColor(.gray3)
                                    
                                    WrappingHStack(alignment: .leading) {
                                        ForEach(locationTags, id: \.self) { tag in
                                            CustomHashtag(tagText: tag) {
                                                locationTags.removeAll(where: { $0 == tag })
                                                checkTags()
                                            }
                                        }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("강조 키워드")
                                            .font(.body1Bold())
                                            .foregroundColor(.gray5)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.gray3)
                                            .onTapGesture(count:1, coordinateSpace: .global) { location in
                                                handlePopoverClick(location: location, clickType: .keyword)
                                            }
                                    }
                                    
                                    ZStack(alignment: .topLeading) {
                                        CustomTextfield(text: $emphasizeText, placeHolder: "마카롱", customTextfieldState: .reuse) {
                                            if !emphasizeText.isEmpty && emphasizeTags.count <= 4 {
                                                emphasizeTags.append(emphasizeText)
                                            } else if emphasizeTags.count > 4 {
                                                showingAlert = true
                                            }
                                        }
                                        .alert(isPresented: $showingAlert) {
                                            Alert(title: Text(""), message: Text("최대 5개까지만 입력할 수 있습니다."),
                                                  dismissButton: .default(Text("확인")))
                                        }
                                    }
                                    
                                    Text("최대 5개까지 작성가능합니다.")
                                        .font(.body2Regular())
                                        .foregroundColor(.gray3)
                                    
                                    WrappingHStack(alignment: .leading) {
                                        ForEach(emphasizeTags, id: \.self) { tag in
                                            CustomHashtag(tagText: tag) {
                                                emphasizeTags.removeAll(where: { $0 == tag })
                                            }
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
                    Task{
                        viewModel.emphasizeKey = emphasizeTags
                        viewModel.locationKey = locationTags
                        viewModel.hashtag = hashtagService.createHashtag(locationArr: locationTags, emphasizeArr: emphasizeTags)
                        
                        SaveHashtag(date: convertDayTime(time: Date()), locationTag: viewModel.locationKey, keyword: viewModel.emphasizeKey, Result: viewModel.hashtag)
                        
                        print(hashtagService.createHashtag(locationArr: locationTags, emphasizeArr: emphasizeTags))
                        
                        pathManager.path.append(.HashtagResult)
                    }
                })
            }
            
            if isShowingDescription {
                popoverView(popupState)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .background(Color.gray5.opacity(0.3))
            }
        }
        .onAppear{FetchHashtag()}
        .navigationBarBackButtonHidden()
    }
}

//MARK: extension: HashtagView Functions
extension HashtagView {
    private func handlePopoverClick(location: CGPoint, clickType: PopOverType) {
        switch clickType {
        case .region:
            regionPopoverOffsetFromTop = location.y
        case .keyword:
            keywordPopoverOffsetFromTop = location.y
        }
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
}

//MARK: extension: HashtagView Views
extension HashtagView {
    @ViewBuilder
    func popoverView(_ type: PopOverType) -> some View {
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
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(width: 166, height: 119)
                .offset(x: 4, y: type == .region ? regionPopoverOffsetFromTop + 26 : keywordPopoverOffsetFromTop + 26)
            }
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
    
    func FetchHashtag() {
        let HashtagRequest = NSFetchRequest<HashtagData>(entityName: "HashtagData")
        
        do {
            let hashtagDataArray = try coreDataManager.context.fetch(HashtagRequest)
            hashtags = hashtagDataArray.map{ hashtagCoreData in
                return HashtagModel(
                    _id: hashtagCoreData.resultId ?? UUID(),
                    _date: hashtagCoreData.date ?? Date(),
                    _locationTag: hashtagCoreData.locationTag ?? [""],
                    _keyword: hashtagCoreData.keyword ?? [""],
                    _hashtag: hashtagCoreData.hashtag ?? ""
                )
            }
        } catch {
            print("ERROR STORE CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func SaveHashtag(date: Date, locationTag: Array<String>, keyword: Array<String>, Result: String) {
        let newHashtag = HashtagData(context: coreDataManager.context)
        newHashtag.resultId = UUID()
        newHashtag.date = date
        newHashtag.hashtag = Result
        coreDataManager.save()
        
        print("Hashtag 저장 완료!\n resultId : \(newHashtag.resultId)\n Date : \(newHashtag.date)\n Hashtag : \(newHashtag.hashtag)\n")
    }
    
}

#Preview {
    HashtagView()
}
