//
//  TitleWithCountView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/13/24.
//

import SwiftUI

struct TitleWithCountView: View {
  @State var title: String
  @State var count: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: -2) {
      Text(title)
        .font(.subheadline)
        .foregroundStyle(.foreground)
      Text("\(count)")
        .font(.caption)
        .foregroundStyle(.gray)
    }
    .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬 및 상위 뷰 크기에 맞춤
  }
}

#Preview {
  TitleWithCountView(title: "사람들", count: 15)
}
