//
//  UIView+.swift
//  iOS-Clone-Photos
//
//  Created by 윤범태 on 8/12/24.
//

import UIKit

extension UIView {
  func allSubviews() -> [UIView] {
    var subviews = self.subviews
    
    for subview in self.subviews {
      let children = subview.allSubviews()
      subviews.append(contentsOf: children)
    }
    
    return subviews
  }
}
