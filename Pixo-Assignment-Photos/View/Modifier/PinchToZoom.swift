//
//  PinchToZoom.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/10/24.
//

import SwiftUI

struct PinchToZoom: ViewModifier {
  @State var scale: CGFloat = 1.0
  @State var anchor: UnitPoint = .center
  @State var offset: CGSize = .zero
  @State var isPinching: Bool = false
  
  func body(content: Content) -> some View {
    withAnimation(isPinching ? .none : .spring()) {
      content
        .scaleEffect(scale, anchor: anchor)
        .offset(offset)
        .overlay(PinchToZoomRepresentedView(
          scale: $scale,
          anchor: $anchor,
          offset: $offset,
          isPinching: $isPinching)
        )
    }
  }
}

extension View {
  func pinchToZoom() -> some View {
    self.modifier(PinchToZoom())
  }
}
