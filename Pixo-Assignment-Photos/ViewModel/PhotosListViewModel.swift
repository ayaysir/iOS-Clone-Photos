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
  @Published var assets: [LibraryImage] = .init()
  
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
  
  func fetch() {
    let requestOptions = PHImageRequestOptions()
    requestOptions.isSynchronous = false
    requestOptions.deliveryMode = .highQualityFormat
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [
      // TODO: - 사진 정렬
      NSSortDescriptor(key: "creationDate", ascending: false)
    ]
    
    let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    
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
