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
      return (1...Int(columnCount)).map { _ in
          GridItem(.flexible(), spacing: MARGIN)
      }
  }
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: MARGIN) {
        ForEach(viewModel.images, id: \.self) { uiImage in
          Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
            .aspectRatio(1, contentMode: .fit)
        }
      }
    }
    .onAppear {
      PhotosListViewModel.requestAuth {
        viewModel.fetch()
      }
    }
  }
}

#Preview {
  PhotosListView()
}
