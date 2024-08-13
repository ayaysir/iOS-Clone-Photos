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
  @State private var showAddToAlbumSheet = false
  
  var columns: [GridItem] {
    (1...Int(columnCount)).map { _ in
      GridItem(.flexible(), spacing: MARGIN)
    }
  }
  
  private func imageContextMenuItems(selectedAsset: LibraryImage) -> some View {
    Group {
      Button {
        Task {
          if let asset = await viewModel.duplicatePhoto(id: selectedAsset.id) {
            withAnimation {
              viewModel.assets.append(asset)
            }
          }
        }
      } label: {
        Label("Duplicate", systemImage: "plus.square.on.square")
      }
      
      Button {
        showAddToAlbumSheet.toggle()
        viewModel.selectedAsset = selectedAsset
      } label: {
        Label("Add to Album", systemImage: "rectangle.stack.badge.plus")
      }
      
      Divider()
      
      Button(role: .destructive) {
        showDeleteActionSheet.toggle()
        viewModel.selectedAsset = selectedAsset
      } label: {
        Label("Delete", systemImage: "trash")
      }
    }
  }
  
  var scrollViewReader: some View {
    ScrollViewReader { scrollProxy in
      ScrollView {
        LazyVGrid(columns: columns, spacing: MARGIN) {
          ForEach(viewModel.assets) { asset in
            NavigationLink {
              DetailView(viewModel: .init(asset: asset))
            } label: {
              ZStack {
                Image(uiImage: asset.image ?? .emptyAlbum)
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
          Spacer()
        }
      }
      .task {
        if await PhotosService.shared.requestPhotosReadWriteAuth(),
           isFirstrun {
          viewModel.fetch()
          
          if #unavailable(iOS 17.0),
             let last = viewModel.assets.last {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
              scrollProxy.scrollTo(last.id, anchor: .bottom)
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
      // .ignoresSafeArea(.all, edges: .top)
      .confirmationDialog("Delete Photo", isPresented: $showDeleteActionSheet) {
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
          Text("Delete Photo")
        }
      } message: {
        Text("This photo will be deleted from iCloud Photos on all your devices. It will be in Recently Deleted for 30 days.")
      }
      .sheet(isPresented: $showAddToAlbumSheet) {
        Group {
          if let selectedAsset = viewModel.selectedAsset {
            AddToAlbumView(viewModel: .init(selectedPhoto: selectedAsset))
          } else {
            Text("No asset selected")
          }
        }
      }
    }
  }
  
  var body: some View {
    switch viewModel.listMode {
    case .album(let albumData):
      scrollViewReader
        .navigationTitle(albumData.title)
        .navigationBarTitleDisplayMode(.inline)
    default:
      NavigationView {
        scrollViewReader
      }
    }
  }
}

#Preview {
  let viewModel = PhotosListViewModel(listMode: .preview)
  viewModel.fetch()
  return PhotosListView(viewModel: viewModel)
}
