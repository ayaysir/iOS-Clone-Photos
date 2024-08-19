//
//  LibraryImage.swift
//  iOS-Clone-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import UIKit
import Photos

struct LibraryImage: Identifiable {
  let id: String
  let name: String
  var image: UIImage?
  let creationDate: Date
  let phAsset: PHAsset?
}
