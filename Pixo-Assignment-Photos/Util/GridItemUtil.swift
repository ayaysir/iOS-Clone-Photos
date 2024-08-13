//
//  GridItemUtil.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/13/24.
//

import SwiftUI

func gridFlexibleColumns(_ rowCount: Int) -> [GridItem] {
  .init(repeating: .init(.flexible()), count: rowCount)
}
