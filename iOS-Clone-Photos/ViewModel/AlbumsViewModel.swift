//
//  AlbumsViewModel.swift
//  iOS-Clone-Photos
//
//  Created by 윤범태 on 8/13/24.
//

import Foundation

@MainActor
final class AlbumsViewModel: ObservableObject {
  @Published var albums: [AlbumData] = []
  
  init() {
    Task {
      await loadAlbums()
    }
  }
  
  func loadAlbums() async {
    self.albums = await PhotosService.shared.loadAlbums()
  }
}
