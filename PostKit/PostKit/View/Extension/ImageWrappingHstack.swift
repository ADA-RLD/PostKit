//
//  ImageWrappingHstack.swift
//  PostKit
//
//  Created by Kim Andrew on 1/26/24.
//

import SwiftUI

struct ImageWrappingHstack: View {
    @Binding var ImageData: [UIImage]

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(ImageData.indices, id: \.self) { index in
                    ZStack {
                        Image(uiImage: ImageData[index])
                            .resizable()
                            .cornerRadius(radius2)
                            .frame(width: 100, height: 100)

                        Image(systemName: "xmark")
                            .foregroundColor(Color.gray4)
                            .bold()
                            .padding(6)
                            .background(Color.gray2)
                            .cornerRadius(radius3)
                            .offset(x: 45, y: -45)
                            .onTapGesture { ImageData.remove(at: index) }
                    }
                    .padding(.top, 15)
                }
            }
        }
    }
}

//#Preview {
//    ImageWrappingHstack()
//}
