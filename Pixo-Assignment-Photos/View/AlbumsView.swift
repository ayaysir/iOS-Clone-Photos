//
//  AlbumsView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import SwiftUI

struct AlbumsView: View {
  let albumGridHeight: CGFloat = 150
  var albumsGridColumns: [GridItem] {
    [
      .init(.flexible()),
      .init(.flexible())
    ]
  }
  
  private func subtitleHeader(_ title: String) -> some View {
    Text(title)
      .font(.title2)
      .bold()
  }
  
  private func albumCell(data: AlbumCellData) -> some View {
    VStack {
      ZStack {
        Image(uiImage: .sample1)
          .resizable()
          .frame(width: albumGridHeight, height: albumGridHeight)
          .foregroundStyle(.gray)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      VStack(alignment: .leading, spacing: -2.4) {
        Text(data.title)
          .font(.subheadline)
        Text("\(data.count)")
          .font(.caption)
          .foregroundStyle(.gray)
      }
      .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬 및 상위 뷰 크기에 맞춤
    }
    .padding(.bottom, 10)
  }
  
  var body: some View {
    ScrollViewReader { reader in
      ScrollView {
        Divider()
        
        VStack(alignment: .leading) {
          HStack {
            subtitleHeader("My Albums")
            Spacer()
            Button {
              
            } label: {
              Text("See All")
            }
          }
          
          ScrollView(.horizontal) {
            LazyHGrid(rows: albumsGridColumns, spacing: 10) {
              ForEach(0..<30) { index in
                albumCell(data: .init(thumbnail: .sample1, title: "Recent", count: index))
              }
            }
          }
          
          Divider()
          
          HStack {
            subtitleHeader("People, Pets & Places")
          }
          
          Divider()
          HStack {
            subtitleHeader("Media Types")
          }
          
          Divider()
          HStack {
            subtitleHeader("Utilities")
          }
        }
      }
      .padding(.horizontal)
    }
    .navigationBarTitleDisplayMode(.large)
    .navigationTitle("Albums")
  }
}

#Preview {
  NavigationView {
    AlbumsView()
  }
}
