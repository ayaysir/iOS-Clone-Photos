//
//  PhotosService.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import UIKit
import Photos

struct PhotosService {
  static let shared = PhotosService()
  private init() {}
  
  /// 사진 권한 설정이 안되어있다면 요청 팝업을 띄우고, 권한 설정이 되어있다면 사진 접근이 가능한 경우 `true`, 아닌 경우 `false`를 반환합니다.
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
  
  /// PHAsset의 섬네일용 이미지를 불러옵니다.
  func loadThumbnailResImage(of phAsset: PHAsset, width: CGFloat = 50) async -> UIImage? {
    return await withCheckedContinuation { continuation in
      let manager = PHCachingImageManager()
      let requestOption = PHImageRequestOptions()
      requestOption.deliveryMode = .highQualityFormat
      requestOption.isSynchronous = false
      
      manager.requestImage(for: phAsset,
                           targetSize: CGSize(width: width, height: width),
                           contentMode: .aspectFill,
                           options: requestOption) { image, info in
        continuation.resume(returning: image)
      }
    }
  }
  
  /// PHAsset의 고해상도 이미지를 불러옵니다.
  func loadHighResImage(of phAsset: PHAsset) async -> UIImage? {
    return await withCheckedContinuation { continuation in
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
  
  /// 사진 라이브러리에 있는 앨범 목록을 불러옵니다.
  func loadAlbums() async -> [AlbumData] {
    var fetchedAlbums: [AlbumData] = []
    
    let fetchOptions = PHFetchOptions()
    let collections = PHAssetCollection.fetchAssetCollections(
      with: .album,
      subtype: .albumRegular,
      options: fetchOptions
    )
    
    for i in 0..<collections.count {
      let collection = collections[i]
      let assets = PHAsset.fetchAssets(in: collection, options: nil)
      
      let thumbnail: UIImage? = await {
        if let firstAsset = assets.firstObject {
          await loadThumbnailResImage(of: firstAsset, width: 300)
        } else {
          nil
        }
      }()
      
      let albumData = AlbumData(
        id: collection.localIdentifier,
        thumbnail: thumbnail,
        title: collection.localizedTitle ?? "Untitled",
        count: assets.count
      )
      
      fetchedAlbums.append(albumData)
    }
    
    return fetchedAlbums
  }
  
  /// PHAsset을 이용해 사진을 삭제합니다.
  func deletePhoto(phAssets: [PHAsset]) {
    PHPhotoLibrary.shared().performChanges {
      PHAssetChangeRequest.deleteAssets(phAssets as NSFastEnumeration)
    }
  }
}
