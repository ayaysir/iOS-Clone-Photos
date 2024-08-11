//
//  PhotosService.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import UIKit
import Photos

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

/// PHAsset의 고해상도 이미지를 불러옵니다.
func loadHighResImage(of phAsset: PHAsset) async -> UIImage? {
  await withCheckedContinuation { continuation in
    let manager = PHCachingImageManager()
    let requestOption = PHImageRequestOptions()
    requestOption.deliveryMode = .highQualityFormat
    requestOption.isSynchronous = false
    
    manager.requestImage(for: phAsset,
                         targetSize: CGSize(width: .max, height: .max),
                         contentMode: .aspectFill,
                         options: requestOption) { image, info in
      continuation.resume(returning: image)
    }
  }
}
