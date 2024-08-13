//
//  AlbumsView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/11/24.
//

import SwiftUI

struct AlbumsView: View {
  @StateObject var viewModel: AlbumsViewModel = .init()
  
  let albumGridHeight: CGFloat = 202.5
  let albumGridSpacing: CGFloat = 10
  
  private func subtitleHeader(_ title: String) -> some View {
    Text(title)
      .font(.title2)
      .bold()
      .foregroundStyle(.foreground)
  }
  
  private func albumCell(data: AlbumData) -> some View {
    NavigationLink {
      if data.count == 0 {
        NotFoundView(
          title: "No Photos or Videos",
          comment: "You can take photos and videos using the camera, or sync photos and videos onto your iPhone using Finder."
        )
      } else {
        PhotosListView(viewModel: .init(listMode: .album(albumData: data)))
      }
    } label: {
      AlbumCellView(data: data)
    }
  }
  
  var body: some View {
    NavigationView {
      List {
        Section {
          ScrollView(.horizontal) {
            LazyHGrid(rows: gridFlexibleColumns(2), spacing: albumGridSpacing) {
              ForEach(viewModel.albums) { album in
                albumCell(data: album)
              }
            }
            .frame(height: albumGridHeight * 2)
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
            LazyHGrid(rows: gridFlexibleColumns(1), spacing: albumGridSpacing) {
              ForEach(0..<30) { index in
                albumCell(data: .init(id: "\(index)", thumbnail: .sample2, title: "Recent", count: index))
              }
            }
            .frame(height: albumGridHeight)
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
}

#Preview {
  AlbumsView()
}
