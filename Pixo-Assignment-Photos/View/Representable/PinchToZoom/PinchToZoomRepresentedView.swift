//
//  PinchToZoomRepresentedView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/10/24.
//

import SwiftUI

struct PinchToZoomRepresentedView: UIViewRepresentable {
  typealias UIViewType = PinchToZoomView
  
  @Binding var scale: CGFloat
  @Binding var anchor: UnitPoint
  @Binding var offset: CGSize
  @Binding var isPinching: Bool
  
  func makeUIView(context: Context) -> PinchToZoomView {
    let pinchZoomView = PinchToZoomView()
    pinchZoomView.delegate = context.coordinator
    return pinchZoomView
  }
  
  func updateUIView(_ uiView: PinchToZoomView, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, PinchToZoomViewDelgate {
    var pinchZoom: PinchToZoomRepresentedView
    
    init(_ representedView: PinchToZoomRepresentedView) {
      self.pinchZoom = representedView
    }
    
    func pinchToZoomView(_ pinchToZoomView: PinchToZoomView, didChangePinching isPinching: Bool) {
      pinchZoom.isPinching = isPinching
    }
    
    func pinchToZoomView(_ pinchToZoomView: PinchToZoomView, didChangeScale scale: CGFloat) {
      pinchZoom.scale = scale
    }
    
    func pinchToZoomView(_ pinchToZoomView: PinchToZoomView, didChangeAnchor anchor: UnitPoint) {
      pinchZoom.anchor = anchor
    }
    
    func pinchToZoomView(_ pinchToZoomView: PinchToZoomView, didChangeOffset offset: CGSize) {
      pinchZoom.offset = offset
    }
  }
}
