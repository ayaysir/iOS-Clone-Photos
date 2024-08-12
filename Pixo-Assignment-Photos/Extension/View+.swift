//
//  View+.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/10/24.
//

import SwiftUI

extension View {
  func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V {
    block(self)
  }
}
