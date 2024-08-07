//
//  PhotoListView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/7/24.
//

import SwiftUI

struct PhotosListView: View {
  @StateObject var viewModel = PhotosListViewModel()
  
  let MARGIN: CGFloat = 3
  @State private var columnCount = 3.0
  
  var columns: [GridItem] {
      (1...Int(columnCount)).map { _ in
          GridItem(.flexible(), spacing: MARGIN)
      }
  }
  
  var body: some View {
    ScrollViewReader { reader in
      ScrollView {
        let modCount = viewModel.assets.count % Int(columnCount)
        if modCount != 0 {
          ForEach(0..<modCount, id: \.self) { _ in
            Rectangle()
              .foregroundStyle(.background)
          }
        }
        
        LazyVGrid(columns: columns, spacing: MARGIN) {
          ForEach(0..<2, id: \.self) { index in
            Rectangle()
              .foregroundStyle(.white)
          }
          ForEach(viewModel.assets) { asset in
            Image(uiImage: asset.image)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
              .clipped()
              .aspectRatio(1, contentMode: .fit)
              // ScrollView가 180도 회전되었으므로 사진도 같이 회전
              .rotationEffect(.degrees(180))
              .onAppear {
                print(asset.id)
              }
          }
        }
        .task {
          if await PhotosListViewModel.requestAuth() {
            viewModel.fetch()
          }
        }
      }
      // ScrollViewReader 대신 사용하면 밑에서부터 역순으로 스크롤한 효과를 낼 수 있음
      .rotationEffect(.degrees(180))
    }
    // .defaultScrollAnchor(.bottom) // iOS 17 이상
  }
}

#Preview {
  PhotosListView()
}
