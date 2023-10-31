//
//  HashtagPopover.swift
//  PostKit
//
//  Created by 신서연 on 2023/10/31.
//

import SwiftUI

enum PopOverType {
    case region
    case keyword
    
    var description : [String] {
      switch self {
      case .region: return [
        "시 단위의 큰 지역",
        "ex) 서울, 부산, 제주...",
        "동 단위의 작은 지역",
        "ex) 성수동, 한남동, 망원동...",
        "지역의 랜드마크",
        "ex) 남산타워, 한강, 서울숲..."
      ]
      case .keyword: return ["Bang"]
      }
    }
    
    var offset : CGSize {
        switch self {
        case .region: return CGSize(width: UIScreen.main.bounds.width/2 - 120, height: -UIScreen.main.bounds.height/2 + 330)
        case .keyword: return CGSize(width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-166)
        }
    }
}

struct HashtagPopover: View {
    @Binding var isShowingDescription: Bool
    
    var body: some View {
        Button(action: {
            // 물음표 아이콘을 누를 때마다 설명 화면 표시 여부를 토글
            withAnimation(.easeInOut){
                isShowingDescription.toggle()
            }
            // 2초 뒤 설명 화면 숨김
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut) {
                    isShowingDescription = false
                }
            }
        }, label: {
            Image(systemName: "info.circle")
                .foregroundColor(.gray3)
        })
        .padding()
    }
}



struct test: View {
    var text: [String]
    var descripiotn: [String]
    var body: some View {
        ForEach(text.indices, id: \.self) { i in
            VStack(alignment: .leading, spacing: 12) {
                Text(text[i])
                Text(descripiotn[i])
            }
            
        }
    }
}
/*
struct popoverText : View {
    var title : String
    var subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(.gray5)
                .font(.body2Bold())
            Text(subtitle)
                .foregroundColor(.gray4)
                .font(.body2Regular())
        }
    }
}*/

struct TriangleView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}


#Preview {
    HashtagPopover(isShowingDescription: .constant(true))
}
