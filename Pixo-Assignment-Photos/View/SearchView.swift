//
//  SearchView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import SwiftUI

struct SearchView: View {
  @State private var searchText = ""
  @State private var noResultComment = "There were no results for \".\"\nTry a new search."
  
  var body: some View {
    NavigationView {
      VStack {
        if searchText.isEmpty {
          NotFoundView(
            title: "No Suggestions",
            comment: "Photos scans your library to offer Search Suggestions. Connect your iPhone to power overnight to continue scanning."
          )
        } else {
          NotFoundView(
            title: "No Results",
            bindingComment: $noResultComment
          )
        }
      }
      .padding()
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Search")
      .searchable(text: $searchText)
      .onChange(of: searchText) { newValue in
        noResultComment = "There were no results for \"\(newValue).\"\nTry a new search."
      }
    }
  }
}

#Preview {
  SearchView()
}
