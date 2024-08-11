//
//  PhotosHelper.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/7/24.
//

import UIKit
import Photos

class PhotosListViewModel: ObservableObject {
  let manager = PHCachingImageManager()
  let isPreview: Bool
  @Published var assetsCount = 0
  @Published var assets: [LibraryImage] = .init()
  @Published var selectedAsset: LibraryImage?
  
  private var result: PHFetchResult<PHAsset>?
  private var thumbnailRequestOption = PHImageRequestOptions()
  
  init(isPreview: Bool = false) {
    self.isPreview = isPreview
    thumbnailRequestOption.deliveryMode = .opportunistic
    thumbnailRequestOption.isSynchronous = false
  }
  
  private func fetchForPreview() {
    let sampleImages: [UIImage] = [.sample1, .sample2, .sample3]
    for i in 0..<50 {
      self.assets.append(
        .init(id: "Temp_\(i)",
              name: "",
              image: sampleImages[i % 3],
              creationDate: .now,
              phAsset: nil)
        )
    }
  }
  
  func fetch(completeHandler: (() -> Void)? = nil) {
    if isPreview {
      fetchForPreview()
      return
    }
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: true)
    ]
    
    result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    
    guard let result else {
      return
    }
    
    assetsCount = result.count
    print(assetsCount)
    
    if result.count > 0 {
      for i in 0..<result.count {
        let asset = result.object(at: i)
        
        guard let creationDate = asset.creationDate else {
          return
        }
        
        let libraryImage = LibraryImage(
          id: asset.localIdentifier,
          name: asset.description,
          image: nil,
          creationDate: creationDate,
          phAsset: asset)
        
        self.assets.append(libraryImage)
      }
    }
  }
  
  func loadPhoto(id: String) {
    guard let index = assets.firstIndex(where: { $0.id == id }),
          let phAsset = assets[index].phAsset,
          assets[index].image == nil else {
      return
    }
    
    manager.requestImage(for: phAsset,
                         targetSize: CGSize(width: 300, height: 300),
                         contentMode: .aspectFill,
                         options: thumbnailRequestOption) { image, info in
      guard let image else {
        return
      }
      
      self.assets[index].image = image
    }
  }
}
