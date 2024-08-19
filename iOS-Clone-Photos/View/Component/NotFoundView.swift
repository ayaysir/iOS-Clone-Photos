//
//  NotFoundView.swift
//  iOS-Clone-Photos
//
//  Created by 윤범태 on 8/12/24.
//

import SwiftUI

struct NotFoundView: View {
  let title: String
  let comment: String
  @Binding var bindingComment: String
  
  init(title: String, comment: String = "", bindingComment: Binding<String> = .constant("")) {
    self.title = title
    self.comment = comment
    self._bindingComment = bindingComment
  }
  
  var body: some View {
    VStack {
      Text(title)
        .font(.title)
        .bold()
      
      if !bindingComment.isEmpty {
        Text(bindingComment)
          .foregroundStyle(.gray)
          .multilineTextAlignment(.center)
      } else {
        Text(comment)
          .foregroundStyle(.gray)
          .multilineTextAlignment(.center)
      }
      
    }
  }
}

#Preview {
  NotFoundView(
    title: "No Photos or Videos",
    comment: "You can take photos and videos using the camera, or sync photos and videos onto your iPhone using Finder."
  )
}
