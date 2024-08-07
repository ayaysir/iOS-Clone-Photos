//
//  PhotosHelper.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/7/24.
//

import UIKit
import Photos

class PhotosListViewModel: ObservableObject {
  let manager = PHImageManager.default()
  @Published var images: [UIImage] = .init()
  
  static func requestAuth(successHandler: @escaping () -> Void) {
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
      switch status {
      case .notDetermined:
        print("PHPhotoLibrary Authorization Status: Not Determined")
      case .restricted:
        print("PHPhotoLibrary Authorization Status: Restricted")
      case .denied:
        print("PHPhotoLibrary Authorization Status: Denied")
      case .authorized:
        print("PHPhotoLibrary Authorization Status: Authorized")
        successHandler()
      case .limited:
        print("PHPhotoLibrary Authorization Status: Limited")
        successHandler()
      @unknown default:
        print("PHPhotoLibrary Authorization Status: Unknown Default")
      }
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
            if let image {
              self.images.append(image)
            } else {
              print("Error: image load failed - \(result[i].localIdentifier)")
            }
          }
      }
    }
  }
}
