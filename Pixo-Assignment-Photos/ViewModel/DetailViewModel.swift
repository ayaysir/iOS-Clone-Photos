//
//  DetailViewModel.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import UIKit

final class DetailViewModel: ObservableObject {
  let asset: LibraryImage
  @Published var highResImage: UIImage?
  @Published var currentZoom = 0.0
  @Published var totalZoom = 1.0
  
  init(asset: LibraryImage, highResImage: UIImage? = nil) {
    self.asset = asset
    self.highResImage = highResImage
  }
}
