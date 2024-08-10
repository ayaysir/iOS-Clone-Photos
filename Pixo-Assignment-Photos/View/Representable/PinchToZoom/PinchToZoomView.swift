//
//  PinchToZoomView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/10/24.
//

import SwiftUI

protocol PinchToZoomViewDelgate: AnyObject {
  func pinchToZoomView(_ pinchToZoomView: PinchToZoomView, didChangePinching isPinching: Bool)
  func pinchToZoomView(_ pinchToZoomView: PinchToZoomView, didChangeScale scale: CGFloat)
  func pinchToZoomView(_ pinchToZoomView: PinchToZoomView, didChangeAnchor anchor: UnitPoint)
  func pinchToZoomView(_ pinchToZoomView: PinchToZoomView, didChangeOffset offset: CGSize)
}

class PinchToZoomView: UIView {
  weak var delegate: PinchToZoomViewDelgate?
  
  private(set) var scale: CGFloat = 0 {
    didSet {
      delegate?.pinchToZoomView(self, didChangeScale: scale)
    }
  }
  
  private(set) var anchor: UnitPoint = .center {
    didSet {
      delegate?.pinchToZoomView(self, didChangeAnchor: anchor)
    }
  }
  
  private(set) var offset: CGSize = .zero {
    didSet {
      delegate?.pinchToZoomView(self, didChangeOffset: offset)
    }
  }
  
  private(set) var isPinching: Bool = false {
    didSet {
      delegate?.pinchToZoomView(self, didChangePinching: isPinching)
    }
  }
  
  private var startLocation: CGPoint = .zero
  private var location: CGPoint = .zero
  private var numberOfTouches: Int = 0
  
  init() {
    super.init(frame: .zero)
    
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
    pinchGesture.cancelsTouchesInView = false
    addGestureRecognizer(pinchGesture)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  @objc private func pinch(gesture: UIPinchGestureRecognizer) {
    switch gesture.state {
    case .began:
      isPinching = true
      startLocation = gesture.location(in: self)
      anchor = UnitPoint(x: startLocation.x / bounds.width,
                         y: startLocation.y / bounds.height)
      numberOfTouches = gesture.numberOfTouches
    case .changed:
      if gesture.numberOfTouches != numberOfTouches {
        let newLocation = gesture.location(in: self)
        let jumpDifference = CGSize(width: newLocation.x - location.x, 
                                    height: newLocation.y - location.y)
        startLocation = CGPoint(x: startLocation.x + jumpDifference.width, 
                                y: startLocation.y + jumpDifference.height)
        
        numberOfTouches = gesture.numberOfTouches
      }
      
      scale = gesture.scale

      location = gesture.location(in: self)
      offset = CGSize(width: location.x - startLocation.x, height: location.y - startLocation.y)
    case .ended, .cancelled, .failed:
      isPinching = false
      scale = 1.0
      anchor = .center
      offset = .zero
    default:
      break
    }
  }
}
