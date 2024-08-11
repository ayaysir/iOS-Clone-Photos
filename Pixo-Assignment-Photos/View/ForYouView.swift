//
//  ForYouView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import SwiftUI

struct ForYouView: View {
    var body: some View {
      VStack {
        Text("No Content")
          .font(.title)
          .bold()
        Text("Photos scans your library to offer content curated for you. Connect your iPhone to power overnight to continue scanning.")
          .foregroundStyle(.gray)
          .multilineTextAlignment(.center)
      }
      .padding()
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("For You")
    }
}

#Preview {
  NavigationView {
    ForYouView()
  }
}
