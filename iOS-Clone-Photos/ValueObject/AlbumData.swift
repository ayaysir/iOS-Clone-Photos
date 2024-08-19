//
//  AlbumCellData.swift
//  iOS-Clone-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import UIKit

struct AlbumData: Identifiable {
  let id: String
  var thumbnail: UIImage?
  var title: String
  var count: Int
}
