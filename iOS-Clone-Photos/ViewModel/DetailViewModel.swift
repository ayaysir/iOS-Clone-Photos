//
//  DetailViewModel.swift
//  iOS-Clone-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import UIKit

final class DetailViewModel: ObservableObject {
  @Published var currentIndex: Int
  @Published var asset: LibraryImage
  @Published var highResImage: UIImage?
  
  init(currentIndex: Int, asset: LibraryImage, highResImage: UIImage? = nil) {
    self.currentIndex = currentIndex
    self.asset = asset
    self.highResImage = highResImage
  }
  
  func loadHighResImage() async -> UIImage? {
    guard let phAsset = asset.phAsset else {
      return nil
    }
    
    return await PhotosService.shared.loadHighResImage(of: phAsset)
  }
}
