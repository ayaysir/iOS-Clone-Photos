//
//  PhotosService.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import UIKit
import Photos

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

/// 사진 라이브러리에 있는 앨범 목록을 불러옵니다.
func loadAlbums() -> [AlbumData] {
  var fetchedAlbums: [AlbumData] = []
  
  let fetchOptions = PHFetchOptions()
  let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
  
  collections.enumerateObjects { collection, _,  _ in
    let assets = PHAsset.fetchAssets(in: collection, options: nil)
    if assets.count > 0 {
      let albumData = AlbumData(id: collection.localIdentifier, thumbnail: .sample1, title: collection.localizedTitle ?? "Untitled", count: assets.count)
      fetchedAlbums.append(albumData)
    }
  }
  
  return fetchedAlbums
}
