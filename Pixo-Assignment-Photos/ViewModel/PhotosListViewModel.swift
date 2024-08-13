//
//  PhotosHelper.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/7/24.
//

import UIKit
import Photos

enum PhotosListMode {
  case preview
  case all
  case album(albumData: AlbumData)
}

final class PhotosListViewModel: ObservableObject {
  let manager = PHCachingImageManager()
  let listMode: PhotosListMode
  
  @Published var assetsCount = 0
  @Published var assets: [LibraryImage] = .init()
  @Published var selectedAsset: LibraryImage?
  
  private var result: PHFetchResult<PHAsset>?
  private var thumbnailRequestOption = PHImageRequestOptions()
  
  init(listMode: PhotosListMode = .all) {
    self.listMode = listMode
    thumbnailRequestOption.deliveryMode = .opportunistic
    thumbnailRequestOption.isSynchronous = false
  }
  
  private func fetchForPreview() {
    let sampleImages: [UIImage] = [.sample1, .sample2, .sample3]
    let maxCount = 50
    assetsCount = maxCount
    
    for i in 0..<maxCount {
      self.assets.append(
        .init(id: "Temp_\(i)",
              name: "",
              image: sampleImages[i % 3],
              creationDate: .now,
              phAsset: nil)
        )
    }
  }
  
  func fetch() {
    switch listMode {
    case .preview:
      fetchForPreview()
      return
    case .all:
      result = PhotosService.shared.fetchAllPhotosList()
    case .album(let albumData):
      result = PhotosService.shared.loadAssets(of: albumData.id)
    }
    
    guard let result else {
      return
    }
    
    assetsCount = result.count
    PhotosService.shared.appendAsset(result: result, to: &assets)
  }
  
  func loadPhoto(id: String) async {
    guard let index = assets.firstIndex(where: { $0.id == id }),
          let phAsset = assets[index].phAsset,
          assets[index].image == nil else {
      return
    }
    
    let image = await PhotosService.shared.loadThumbnailResImage(of: phAsset, width: 300)
    DispatchQueue.main.async {
      self.assets[index].image = image
    }
  }
  
  func deletePhoto(id: String) async -> Int? {
    guard let index = assets.firstIndex(where: { $0.id == id }),
          let phAsset = assets[index].phAsset else {
      return nil
    }
    
    if await PhotosService.shared.deletePhoto(phAssets: [phAsset]) {
      return index
    }
    
    return nil
  }
  
  func duplicatePhoto(id: String) async -> LibraryImage? {
    guard let index = assets.firstIndex(where: { $0.id == id }),
          let phAsset = assets[index].phAsset else {
      return nil
    }
    
    if await PhotosService.shared.duplicatePhoto(phAsset: phAsset),
       let phAsset = PhotosService.shared.fetchLatestPhoto() {
      
      return .init(
        id: phAsset.localIdentifier,
        name: phAsset.description,
        creationDate: phAsset.creationDate ?? .now,
        phAsset: phAsset
      )
    }
    
    return nil
  }
}
