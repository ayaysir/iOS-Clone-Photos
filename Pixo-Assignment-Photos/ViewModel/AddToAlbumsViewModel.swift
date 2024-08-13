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
      await loadAlbums()
    }
  }
  
  func loadAlbums() async {
    self.albums = await PhotosService.shared.loadAlbums()
  }
  
  func addToAlbum(asset: LibraryImage, to album: AlbumData) async -> Bool {
    guard let phAsset = asset.phAsset,
      let collection = PhotosService.shared.loadCollection(of: album.id) else {
      return false
    }
    
    return await PhotosService.shared.addPhotoToAlbum(phAsset: phAsset, album: collection)
  }
  
  func createNewAlbum(title: String) async -> Bool {
    let result = await PhotosService.shared.createAlbum(title: title)
    if result {
      await loadAlbums()
    }
    
    return result
  }
}
