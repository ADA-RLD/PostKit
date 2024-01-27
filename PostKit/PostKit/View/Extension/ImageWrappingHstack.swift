//
//  ImageWrappingHstack.swift
//  PostKit
//
//  Created by Kim Andrew on 1/26/24.
//

import SwiftUI

struct ImageWrappingHstack: View {
    @Binding var ImageData: UIImage
    
    var body: some View {
        ZStack{
            Image(uiImage: ImageData)
                .resizable()
                .scaledToFill()
            
            Image(systemName: "xmark")
                .background(in: RoundedRectangle(cornerRadius: radius3))
                .offset(x: 16, y: -16)
        }
    }
}

//#Preview {
//    ImageWrappingHstack()
//}
