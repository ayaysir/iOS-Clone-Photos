//
//  PhotoListView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/7/24.
//

import SwiftUI

struct PhotosListView: View {
  @StateObject var viewModel: PhotosListViewModel
  
  let MARGIN: CGFloat = 3
  @State private var columnCount = 3.0
  @State private var isFirstrun = true
  
  var columns: [GridItem] {
    (1...Int(columnCount)).map { _ in
      GridItem(.flexible(), spacing: MARGIN)
    }
  }
  
  var body: some View {
    NavigationView {
      ScrollViewReader { reader in
        ScrollView {
          LazyVGrid(columns: columns, spacing: MARGIN) {
            let mod = Int(columnCount) - (viewModel.assetsCount % Int(columnCount))
            let _ = print(viewModel.assetsCount, mod)
            ForEach(0..<mod, id: \.self) { _ in
              Rectangle()
                .foregroundStyle(.white)
            }
            
            ForEach(viewModel.assets) { asset in
              NavigationLink {
                DetailView(asset: asset)
              } label: {
                ZStack {
                  Image(uiImage: asset.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                }
                // ScrollView가 180도 회전되었으므로 사진도 같이 회전
                .rotationEffect(.degrees(180))
              }
            }
            
          }
          
          
        }
        .task {
          if await PhotosListViewModel.requestAuth(), isFirstrun {
            viewModel.fetch()
            // 중복 fetch 방지
            isFirstrun = false
          }
        }
        // ScrollViewReader 대신 사용하면 밑에서부터 역순으로 스크롤한 효과를 낼 수 있음
        .rotation3DEffect(
          .degrees(180),
          axis: (x: 1.0, y: 0.0, z: 0.0)
        )
        .rotation3DEffect(
          .degrees(180),
          axis: (x: 0.0, y: 1.0, z: 0.0)
        )
      }
      // .defaultScrollAnchor(.bottom) // iOS 17 이상
    }
  }
}

#Preview {
  let viewModel = PhotosListViewModel(isPreview: true)
  viewModel.fetch()
  return PhotosListView(viewModel: viewModel)
}
