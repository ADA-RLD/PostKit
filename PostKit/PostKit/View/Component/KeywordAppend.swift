//
//  KeywordAppend.swift
//  PostKit
//
//  Created by 김다빈 on 11/2/23.
//

import SwiftUI
import Photos
import PhotosUI

struct KeywordAppend: View {
//    let accessLevel: PHAccessLevel = .readWrite
//    let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: accessLevel)
    
    @Binding var isModalToggle: Bool
    @Binding var selectKeyWords: [String]
    @Binding var openPhoto : Bool
    @Binding var selectedImage : [UIImage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 8) {
                Text("키워드")
                    .body1Bold(textColor: .gray5)
                
                Text("\(selectKeyWords.count)/5")
                    .body2Bold(textColor: .gray4)
                
                Spacer()
                
            }
            
            if !selectKeyWords.isEmpty {
                WrappingHStack(alignment: .leading,horizontalSpacing: 8, verticalSpacing: 8) {
                    ForEach(selectKeyWords, id: \.self) { index in
                        CustomHashtag(tagText: index) {
                            selectKeyWords.removeAll(where: { $0 == index})
                        }
                    }
                }
            }
            
            if selectKeyWords.count < 5 {
                Button(action: {
                    isModalToggle.toggle()
                    
                }, label: {
                    Text("+ 키워드 추가")
                        .body1Bold(textColor: Color.gray5)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18.5)
                        .background(Color.gray1)
                        .background(in: RoundedRectangle(cornerRadius: radius1))
                })
            }
            
            HStack(spacing: 8) {
                Text("이미지")
                    .body1Bold(textColor: .gray5)
                
                Text("\(selectedImage.count)/1")
                    .body2Bold(textColor: .gray4)
                
                Spacer()
                
            }
            
            ImageWrappingHstack(ImageData: $selectedImage)
            
            if !(selectedImage == nil) && !(selectedImage.count == 1) {
                Button(action: {
                    requestPHPhotoLibraryAuthorization{
                        //getCanAccessImages()
                    }
                }, label: {
                    Text("이미지 추가")
                        .body1Bold(textColor: Color.gray5)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18.5)
                        .background(Color.gray1)
                        .background(in: RoundedRectangle(cornerRadius: radius1))
                })
            }
        }
    }
}

extension KeywordAppend {
    func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
            switch status {
            case .limited, .authorized:
                //completion()
                openPhoto.toggle()
            //case .authorized:
                //completion()
            default:
                break
            }
        }
    }

    func getCanAccessImages() {
        self.selectedImage = []
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true

        let fetchOptions = PHFetchOptions()
        var fetchResult = PHAsset.fetchAssets(with: fetchOptions)
      
        fetchResult.enumerateObjects { (asset, _, _) in
            PHImageManager().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: requestOptions) { (image, info) in
                guard let image = image else { return }
                self.selectedImage.append(image)
                
            }
        }
    }

}
//#Preview {
//    KeywordAppend(selectKeyWords: .constant(["ds"]))
//}
