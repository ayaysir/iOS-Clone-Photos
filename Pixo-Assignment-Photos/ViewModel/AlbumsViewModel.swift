//
//  AlbumsViewModel.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/13/24.
//

import Foundation

@MainActor
final class AlbumsViewModel: ObservableObject {
  @Published var albums: [AlbumData] = []
  
  init() {
    Task {
      self.albums = await PhotosService.shared.loadAlbums()
    }
  }
}
