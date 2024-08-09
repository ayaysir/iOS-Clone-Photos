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

class PhotosListViewModel: ObservableObject {
  let manager = PHImageManager.default()
  let isPreview: Bool
  @Published var assetsCount = 0
  @Published var assets: [LibraryImage] = .init()
  @Published var selectedAsset: LibraryImage?
  
  init(isPreview: Bool = false) {
    self.isPreview = isPreview
  }
  
  static func requestAuth() async -> Bool {
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
  
  private func fetchForPreview() {
    let now = Date.now
    assets = [
      .init(id: "Test1", name: "", image: .init(resource: .sample1), creationDate: .init(timeIntervalSince1970: 1690900323)),
      .init(id: "Test2", name: "", image: .init(resource: .sample2), creationDate: .init(timeIntervalSince1970: now.timeIntervalSince1970 - 432000)),
      .init(id: "Test3", name: "", image: .init(resource: .sample3), creationDate: now)
    ]
  }
  
  func fetch() {
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
      NSSortDescriptor(key: "creationDate", ascending: false)
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
          }
      }
    }
  }
}
