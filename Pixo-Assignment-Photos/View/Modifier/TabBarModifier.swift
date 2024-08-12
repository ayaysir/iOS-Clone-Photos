//
//  TabBarModifier.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/12/24.
//

import SwiftUI

struct TabBarModifier {
  static func showTabBar() {
    UIApplication.shared.key?.allSubviews().forEach { subview in
      if let view = subview as? UITabBar {
        view.isHidden = false
      }
    }
  }
  
  static func hideTabBar() {
    UIApplication.shared.key?.allSubviews().forEach { subview in
      if let view = subview as? UITabBar {
        view.isHidden = true
      }
    }
  }
}

struct ShowTabBar: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding(.zero)
      .onAppear {
        TabBarModifier.showTabBar()
      }
  }
}

struct HideTabBar: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding(.zero)
      .onAppear {
        TabBarModifier.hideTabBar()
      }
  }
}

extension View {
  func showTabBar() -> some View {
    modifier(ShowTabBar())
  }
  
  func hideTabBar() -> some View {
    modifier(HideTabBar())
  }
}
