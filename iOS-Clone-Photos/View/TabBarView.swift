//
//  TabBarView.swift
//  iOS-Clone-Photos
//
//  Created by 윤범태 on 8/6/24.
//

import SwiftUI

struct TabBarView: View {
  @StateObject var photosListViewModel = PhotosListViewModel()
  
  var body: some View {
    TabView {
      PhotosListView(viewModel: photosListViewModel)
        .tabItem {
          IconWithTextView(image: .init(systemName: "photo.fill.on.rectangle.fill"), text: "Library")
        }
      ForYouView()
        .tabItem {
          IconWithTextView(image: .init(systemName: "heart.text.square"), text: "For You")
        }
      AlbumsView()
        .tabItem {
          IconWithTextView(image: .init(systemName: "square.stack.fill"), text: "Albums")
        }
      SearchView()
        .tabItem {
          IconWithTextView(image: .init(systemName: "magnifyingglass"), text: "Search")
        }
    }
  }
}

#Preview {
  let viewModel = PhotosListViewModel(listMode: .preview)
  viewModel.fetch()
  return TabBarView(photosListViewModel: viewModel)
}
