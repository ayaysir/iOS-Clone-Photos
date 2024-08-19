//
//  IconWithText.swift
//  iOS-Clone-Photos
//
//  Created by 윤범태 on 8/6/24.
//

import SwiftUI

struct IconWithTextView: View {
  let image: Image
  let text: String
  
  var body: some View {
    image
    Text(text)
  }
}

#Preview {
  IconWithTextView(image: .init(systemName: "magnifyingglass"), text: "검색")
}
