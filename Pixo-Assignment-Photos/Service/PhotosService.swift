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
  
  /// 사진 라이브러리의 전체 리스트를 불러옵니다.
  func fetchAllPhotosList() -> PHFetchResult<PHAsset>? {
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: true)
    ]
    
    return PHAsset.fetchAssets(with: .image, options: fetchOptions)
  }
  
  /// 최신 사진 1장의 PHAsset을 가져옵니다.
  func fetchLatestPhoto() -> PHAsset? {
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: false) // 내림차순 정렬
    ]
    fetchOptions.fetchLimit = 1 // 첫번째(최신) 1개만 가져옴
    
    return PHAsset.fetchAssets(with: .image, options: fetchOptions).firstObject
  }
  
  /// result로부터 가공하여 [LibraryImage] 배열에 추가합니다.
  func appendAsset(result: PHFetchResult<PHAsset>, to assets: inout [LibraryImage]) {
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
        
        assets.append(libraryImage)
      }
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
    fetchOptions.sortDescriptors = [
      NSSortDescriptor(key: "endDate", ascending: false) // 내림차순 정렬
    ]
    
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
  
  func loadCollection(of collectionId: String) -> PHAssetCollection? {
    let fetchOptions = PHFetchOptions()
    // collection.localIdentifier가 특정 값인 경우만 가져옴
    fetchOptions.predicate = NSPredicate(format: "localIdentifier == %@", collectionId)

    let collections = PHAssetCollection.fetchAssetCollections(
        with: .album,
        subtype: .albumRegular,
        options: fetchOptions
    )
    
    return collections.firstObject
  }
  
  /// 앨범 id를 이용해 앨범 내의 사진들을 불러옵니다.
  func loadAssets(of collectionId: String) -> PHFetchResult<PHAsset>? {
    guard let collection = loadCollection(of: collectionId) else {
      return nil
    }
    
    return PHAsset.fetchAssets(in: collection, options: nil)
  }
  
  /// PHAsset을 이용해 사진을 삭제합니다.
  /// - Parameter phAssets: 삭제할 `PHAsset` 객체들의 배열.
  /// - Returns: 삭제 작업이 성공하면 `true`, 실패하면 `false`를 반환합니다.
  func deletePhoto(phAssets: [PHAsset]) async -> Bool {
    return await withCheckedContinuation { continuation in
      PHPhotoLibrary.shared().performChanges {
        PHAssetChangeRequest.deleteAssets(phAssets as NSFastEnumeration)
        
      } completionHandler: { isSuccess, error in
        continuation.resume(returning: isSuccess)
      }
    }
  }
  
  /// 선택한 사진을 복제합니다.
  /// - Returns: 복제 작업이 성공하면 `true`, 실패하면 `false`를 반환합니다.
  func duplicatePhoto(phAsset: PHAsset) async -> Bool {
    return await withCheckedContinuation { continuation in
      PHImageManager.default().requestImageDataAndOrientation(
        for: phAsset, options: nil) { imageData, dataUTI, orientation, info in
          guard let imageData else {
            return continuation.resume(returning: false)
          }
          
          PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, data: imageData, options: nil)
          } completionHandler: { isSuccess, error in
            continuation.resume(returning: isSuccess)
          }
        }
    }
  }
  
  /// 사진을 앨범에 추가합니다.
  func addPhotoToAlbum(phAsset: PHAsset, album: PHAssetCollection) async -> Bool {
    return await withCheckedContinuation { continuation in
      PHPhotoLibrary.shared().performChanges {
        if let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) {
          // PHObjectPlaceholder를 통해 추가할 자산을 요청합니다.
          _ = PHObjectPlaceholder()
          
          // 앨범에 해당 사진을 추가합니다.
          albumChangeRequest.addAssets([phAsset] as NSArray)
        }
      } completionHandler: { isSuccess, error in
        continuation.resume(returning: isSuccess)
      }
    }
  }
  
  /// 새로운 앨범을 생성합니다.
  func createAlbum(title: String) async -> Bool {
    return await withCheckedContinuation { continuation in
      PHPhotoLibrary.shared().performChanges {
        PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
      } completionHandler: { isSuccess, error in
        continuation.resume(returning: isSuccess)
      }
    }
  }
}
