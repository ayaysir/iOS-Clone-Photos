//
//  TabBarView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/6/24.
//

import SwiftUI

struct TabBarView: View {
  var body: some View {
    TabView {
      Text("1")
        .tabItem {
          IconWithText(image: .init(systemName: "photo.fill.on.rectangle.fill"), text: "보관함")
        }
      Text("2")
        .tabItem { 
          IconWithText(image: .init(systemName: "heart.text.square"), text: "For You")
        }
      Text("3")
        .tabItem {
          IconWithText(image: .init(systemName: "square.stack.fill"), text: "앨범")
        }
      Text("4")
        .tabItem {
          IconWithText(image: .init(systemName: "magnifyingglass"), text: "검색")
        }
    }
  }
}

#Preview {
  TabBarView()
}
