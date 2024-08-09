//
//  PhotosHelper.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/7/24.
//

import UIKit
import Photos

struct LibraryImage: Identifiable {
  let id: String
  let name: String
  let image: UIImage
  let creationDate: Date
}

func requestPhotosReadWriteAuth() async -> Bool {
  let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
  return switch status {
  case .notDetermined, .restricted, .denied:
    false
  case .authorized, .limited:
    true
  @unknown default:
    false
  }
}

class PhotosListViewModel: ObservableObject {
  let manager = PHImageManager.default()
  let isPreview: Bool
  @Published var assetsCount = 0
  @Published var assets: [LibraryImage] = .init()
  @Published var selectedAsset: LibraryImage?
  
  init(isPreview: Bool = false) {
    self.isPreview = isPreview
  }
  
  private func fetchForPreview() {
    let sampleImages: [UIImage] = [.sample1, .sample2, .sample3]
    for i in 0..<50 {
      self.assets.append(.init(id: "Temp_\(i)", name: "", image: sampleImages[i % 3], creationDate: .now))
    }
  }
  
  func fetch(completeHandler: (() -> Void)? = nil) {
    if isPreview {
      fetchForPreview()
      return
    }
    
    let requestOptions = PHImageRequestOptions()
    requestOptions.isSynchronous = true
    requestOptions.deliveryMode = .highQualityFormat
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [
      // TODO: - 사진 정렬
      NSSortDescriptor(key: "creationDate", ascending: true)
    ]
    
    let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    assetsCount = result.count
    
    if result.count > 0 {
      for i in 0..<result.count {
        let asset = result.object(at: i)
        let size = CGSize(width: 700, height: 700)
        
        manager.requestImage(
          for: asset,
          targetSize: size,
          contentMode: .aspectFill,
          options: requestOptions) { image, _ in
            if let image, let creationDate = asset.creationDate {
              let libraryImage = LibraryImage(
                id: asset.localIdentifier,
                name: asset.description,
                image: image,
                creationDate: creationDate)
              
              self.assets.append(libraryImage)
            } else {
              print("Error: image load failed - \(result[i].localIdentifier)")
            }
            
            if i == result.count - 1 {
              completeHandler?()
            }
          }
      }
    }
  }
  
}
