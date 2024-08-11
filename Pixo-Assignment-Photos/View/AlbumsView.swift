//
//  AlbumsView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import SwiftUI

struct AlbumsView: View {
  let albumGridHeight: CGFloat = 150
  
  private func albumGridColumns(_ rowCount: Int) -> [GridItem] {
    var result: [GridItem] = []
    for i in 0..<rowCount {
      result.append(.init(.flexible()))
    }
    
    return result
  }
  
  private func subtitleHeader(_ title: String) -> some View {
    Text(title)
      .font(.title2)
      .bold()
      .foregroundStyle(.foreground)
  }
  
  private func albumCell(data: AlbumCellData) -> some View {
    VStack {
      ZStack {
        Image(uiImage: data.thumbnail)
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
  }
  
  var body: some View {
    List {
      Section {
        ScrollView(.horizontal) {
          LazyHGrid(rows: albumGridColumns(2), spacing: 10) {
            ForEach(0..<30) { index in
              albumCell(data: .init(thumbnail: .sample1, title: "Recent", count: index))
            }
          }
        }
      } header: {
        HStack {
          subtitleHeader("My Albums")
          Spacer()
          Button {
            
          } label: {
            Text("See All")
          }
        }
      }
      
      Section {
        ScrollView(.horizontal) {
          LazyHGrid(rows: albumGridColumns(1), spacing: 10) {
            ForEach(0..<30) { index in
              albumCell(data: .init(thumbnail: .sample2, title: "Recent", count: index))
            }
          }
        }
      } header: {
        subtitleHeader("People, Pets & Places")
      }
      
      Section {
        NavigationLink(destination: Text("Videos")) {
          HStack {
            Image(systemName: "video.fill")
              .foregroundColor(.blue)
            Text("Videos")
              .foregroundColor(.blue)
            Spacer()
            Text("1")
              .foregroundColor(.gray)
          }
        }
        
        NavigationLink(destination: Text("Screenshots")) {
          HStack {
            Image(systemName: "camera.viewfinder")
              .foregroundColor(.blue)
            Text("Screenshots")
              .foregroundColor(.blue)
            Spacer()
            Text("6")
              .foregroundColor(.gray)
          }
        }
      } header: {
        subtitleHeader("Media Types")
      }
      
      Section {
        NavigationLink(destination: Text("Imports")) {
          HStack {
            Image(systemName: "square.and.arrow.down")
              .foregroundColor(.blue)
            Text("Imports")
              .foregroundColor(.blue)
            Spacer()
            Text("0")
              .foregroundColor(.gray)
          }
        }
        
        NavigationLink(destination: Text("Duplicates")) {
          HStack {
            Image(systemName: "rectangle.on.rectangle")
              .foregroundColor(.blue)
            Text("Duplicates")
              .foregroundColor(.blue)
            Spacer()
            Text("0")
              .foregroundColor(.gray)
          }
        }
        
        NavigationLink(destination: Text("Hidden")) {
          HStack {
            Image(systemName: "eye.slash")
              .foregroundColor(.blue)
            Text("Hidden")
              .foregroundColor(.blue)
            Spacer()
            Image(systemName: "lock.fill")
              .foregroundColor(.gray)
          }
        }
        
        NavigationLink(destination: Text("Recently Deleted")) {
          HStack {
            Image(systemName: "trash.fill")
              .foregroundColor(.blue)
            Text("Recently Deleted")
              .foregroundColor(.blue)
            Spacer()
            Image(systemName: "lock.fill")
              .foregroundColor(.gray)
          }
        }
      } header: {
        subtitleHeader("Utilities")
      }
    }
    .listStyle(.inset)
    .navigationBarTitleDisplayMode(.large)
    .navigationTitle("Albums")
  }
}

#Preview {
  NavigationView {
    AlbumsView()
  }
}
