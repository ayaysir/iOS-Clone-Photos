//
//  ForYouView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import SwiftUI

struct ForYouView: View {
  var body: some View {
    NavigationView {
      NotFoundView(
        title: "No Content",
        comment: "Photos scans your library to offer content curated for you. Connect your iPhone to power overnight to continue scanning."
      )
      .padding()
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("For You")
    }
  }
}

#Preview {
  ForYouView()
}
