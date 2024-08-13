//
//  PhotoDetailRepresentedViewModel.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/13/24.
//

import Foundation

final class PhotoDetailRepresentedViewModel: ObservableObject {
  @Published var isFullscreen = false
  @Published var currentScale: CGFloat = 1.0
}
