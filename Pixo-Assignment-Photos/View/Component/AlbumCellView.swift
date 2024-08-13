//
//  AlbumCellView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/13/24.
//

import SwiftUI

struct AlbumCellView: View {
  let data: AlbumData
  
  var body: some View {
    VStack {
      Image(uiImage: data.thumbnail ?? .emptyAlbum)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 10))
      
      VStack(alignment: .leading, spacing: -2) {
        Text(data.title)
          .font(.subheadline)
          .foregroundStyle(.foreground)
        Text("\(data.count)")
          .font(.caption)
          .foregroundStyle(.gray)
      }
      .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬 및 상위 뷰 크기에 맞춤
    }
  }
}

#Preview {
  AlbumCellView(data: .init(id: "Test1", thumbnail: .sample1, title: "앨범", count: 5))
}
