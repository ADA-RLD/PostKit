//
//  CustomHeader.swift
//  PostKit
//
//  Created by 김다빈 on 10/13/23.
//

import SwiftUI

struct CustomHeader: View {
    var action: () -> Void
    var title: String
    var body: some View {
        HStack() {
            Button(action: {
                action()
            }, label: {
                Image(systemName: "chevron.backward")
            })
            .padding(.leading,16)
            Spacer()
            Text(title)
                .font(.body1Bold())
            Spacer()
        }.frame(height: 60)
    }
}

struct OnboardingCustomHeader: View {
    var action: () -> Void
    var body: some View {
        HStack {
            Button(action: {
                action()
            }, label: {
                Image(systemName: "chevron.backward")
            })
            Spacer()
            .padding(.leading,16)
            
            
        }
    }
}

#Preview {
    CustomHeader(action: {print("")}, title: "내용")
}
