//
//  AddToAlbumsViewModel.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/13/24.
//

import Foundation

@MainActor
final class AddToAlbumsViewModel: ObservableObject {
  @Published var albums: [AlbumData] = []
  @Published var selectedPhoto: LibraryImage
  
  init(selectedPhoto: LibraryImage) {
    self.selectedPhoto = selectedPhoto
    
    Task {
      self.albums = await PhotosService.shared.loadAlbums()
    }
  }
}
