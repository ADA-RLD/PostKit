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
                .frame(width: 100, height: 100)
            
            Image(systemName: "xmark")
                .background(in: RoundedRectangle(cornerRadius: radius3))
                .padding(6)
                .offset(x: 40, y: -40)
        }
    }
}

//#Preview {
//    ImageWrappingHstack()
//}
