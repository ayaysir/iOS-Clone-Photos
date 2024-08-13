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
      
      TitleWithCountView(title: data.title, count: data.count)
    }
  }
}

#Preview {
  AlbumCellView(data: .init(id: "Test1", thumbnail: .sample1, title: "앨범", count: 5))
}
