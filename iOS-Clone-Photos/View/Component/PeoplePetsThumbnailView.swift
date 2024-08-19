//
//  PeoplePetsThumbnailView.swift
//  iOS-Clone-Photos
//
//  Created by 윤범태 on 8/13/24.
//

import SwiftUI

struct PeoplePetsThumbnailView: View {
  @State var thumbnails: [UIImage] = [
    .person1,
    .person2,
    .pet1,
    .pet2
  ]
  
  func circle(thumbnail: UIImage) -> some View {
    Image(uiImage: thumbnail)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .aspectRatio(1, contentMode: .fit)
      .clipped()
      .clipShape(Circle())
  }
  
  var body: some View {
    VStack {
      LazyVGrid(columns: gridFlexibleColumns(2)) {
        ForEach(thumbnails, id: \.self) { thumbnail in
          circle(thumbnail: thumbnail)
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .aspectRatio(1, contentMode: .fit)
      
      TitleWithCountView(title: "사람들 및 반려동물", count: 8)
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
  }
}

#Preview {
  PeoplePetsThumbnailView()
}
