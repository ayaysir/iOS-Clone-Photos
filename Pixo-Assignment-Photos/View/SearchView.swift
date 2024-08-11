//
//  SearchView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import SwiftUI

struct SearchView: View {
  @State private var searchText = ""
  
  var body: some View {
    NavigationView {
      VStack {
        if searchText.isEmpty {
          Text("No Suggestions")
            .font(.title)
            .bold()
          Text("Photos scans your library to offer Search Suggestions. Connect your iPhone to power overnight to continue scanning.")
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
        } else {
          Text("No Results")
            .font(.title)
            .bold()
          Text("There were no results for \"\(searchText).\"\nTry a new search.")
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
        }
        
      }
      .padding()
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Search")
      .searchable(text: $searchText)
    }
  }
}

#Preview {
  SearchView()
}
