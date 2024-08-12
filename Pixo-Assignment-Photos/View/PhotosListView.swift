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
  
  var imageContextMenuItems: some View {
    Group {
      Button {
        
      } label: {
        Label("앨범에 추가", systemImage: "rectangle.stack.badge.plus")
      }
      
      Divider()
      
      Button(role: .destructive) {
        
      } label: {
        Label("삭제", systemImage: "trash")
      }
    }
  }
  
  var body: some View {
    NavigationView {
      ScrollViewReader { scrollProxy in
        ScrollView {
          LazyVGrid(columns: columns, spacing: MARGIN) {
            ForEach(viewModel.assets) { asset in
              NavigationLink {
                DetailView(viewModel: .init(asset: asset))
              } label: {
                ZStack {
                  Image(uiImage: asset.image ?? .sample1)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                }
                .task {
                  await viewModel.loadPhoto(id: asset.id)
                }
                .apply {
                  if #available(iOS 16.0, *) {
                    $0.contextMenu {
                      imageContextMenuItems
                    } preview: {
                      Image(uiImage: asset.image ?? .sample1)
                        .resizable()
                    }
                  } else {
                    $0.contextMenu(menuItems: {
                      imageContextMenuItems
                    })
                  }
                }
              }
            }
          }
        }
        .task {
          if await PhotosService.shared.requestPhotosReadWriteAuth(),
             isFirstrun {
            viewModel.fetch {
              if #unavailable(iOS 17.0),
                 let last = viewModel.assets.last {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
                  scrollProxy.scrollTo(last.id, anchor: .bottom)
                }
              }
            }
            
            isFirstrun = false
          }
        }
        .apply {
          if #available(iOS 17.0, *) {
            $0.defaultScrollAnchor(.bottom)
          }
        }
      }
    }
  }
}

#Preview {
  let viewModel = PhotosListViewModel(isPreview: true)
  viewModel.fetch()
  return PhotosListView(viewModel: viewModel)
}
