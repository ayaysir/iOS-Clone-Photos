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
  @State private var showDeleteActionSheet = false
  
  var columns: [GridItem] {
    (1...Int(columnCount)).map { _ in
      GridItem(.flexible(), spacing: MARGIN)
    }
  }
  
  private func imageContextMenuItems(selectedAsset: LibraryImage) -> some View {
    Group {
      Button {
        
      } label: {
        Label("앨범에 추가", systemImage: "rectangle.stack.badge.plus")
      }
      
      Divider()
      
      Button(role: .destructive) {
        showDeleteActionSheet.toggle()
        viewModel.selectedAsset = selectedAsset
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
                    .transition(.opacity.combined(with: .scale)) // Transition for disappearance
                    .animation(.easeInOut, value: asset.id) // Animation for transition
                }
                .task {
                  await viewModel.loadPhoto(id: asset.id)
                }
                .apply {
                  if #available(iOS 16.0, *) {
                    $0.contextMenu {
                      imageContextMenuItems(selectedAsset: asset)
                    } preview: {
                      Image(uiImage: asset.image ?? .sample1)
                        .resizable()
                    }
                  } else {
                    $0.contextMenu(menuItems: {
                      imageContextMenuItems(selectedAsset: asset)
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
        .confirmationDialog("사진 삭제 경고", isPresented: $showDeleteActionSheet) {
          Button(role: .destructive) {
            if let selectedAsset = viewModel.selectedAsset {
              Task {
                if let index = await viewModel.deletePhoto(id: selectedAsset.id) {
                  _ = withAnimation {
                    viewModel.assets.remove(at: index)
                  }
                }
              }
            }
          } label: {
            Text("사진 삭제")
          }
        } message: {
          Text("이 사진이 기기에서 삭제됩니다. 해당 사진은 '최근 삭제된 항목'에 30일간 보관됩니다.")
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
