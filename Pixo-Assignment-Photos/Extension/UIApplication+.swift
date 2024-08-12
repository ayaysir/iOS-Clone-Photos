//
//  UIApplication+.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/12/24.
//

import UIKit

extension UIApplication {
  var key: UIWindow? {
    self.connectedScenes
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?
      .windows
      .filter { $0.isKeyWindow }
      .first
  }
}
