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
    @State private var isActive: Bool = false
    @State private var locationTags: [String] = []
    @State private var emphasizeTags: [String] = []
    
    //CoreData Manager
    private let coreDataManager = CoreDataManager.instance
    
    //CoreData Class
    @State private var hashtags: [HashtagModel] = []
    
    var body: some View {
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
                                Text("지역명 *")
                                    .font(.body1Bold())
                                    .foregroundColor(.gray5)
                                CustomTextfield(text: $locationText, placeHolder: "한남동", customTextfieldState: .reuse) {
                                    if !locationText.isEmpty {
                                        locationTags.append(locationText)
                                        checkTags()
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
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("강조키워드")
                                    .font(.body1Bold())
                                    .foregroundColor(.gray5)
                                CustomTextfield(text: $emphasizeText, placeHolder: "마카롱", customTextfieldState: .reuse) {
                                    if !emphasizeText.isEmpty {
                                        emphasizeTags.append(emphasizeText)
                                        
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
                }
                .scrollIndicators(.hidden)
            }
            Spacer()
            CTABtn(btnLabel: "해시태그 생성", isActive: self.$isActive, action: {})
        }
        .onAppear{FetchHashtag()}
        .navigationBarBackButtonHidden()
    }
    
    private func checkTags() {
        if !locationTags.isEmpty {
            isActive = true
        } else {
            isActive = false
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
        //결과는 HashtagResultView에서 저장합니다.
    }
    
}

#Preview {
    HashtagView()
}
