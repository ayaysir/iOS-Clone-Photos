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
              PeoplePetsThumbnailView()
              
              let thumbnails: [UIImage] = [
                .sample1,
                .sample2,
                .sample3,
              ]
              
              ForEach(0..<30) { index in
                albumCell(data: .init(id: "\(index)", thumbnail: thumbnails[index % 3], title: "Recent \(index)", count: 0))
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
              Label("Videos", systemImage: "video.fill")
                .foregroundColor(.blue)
              Spacer()
              Text("0")
                .foregroundColor(.gray)
            }
          }
          
          NavigationLink(destination: Text("Screenshots")) {
            HStack {
              Label("Screenshots", systemImage: "camera.viewfinder")
                .foregroundColor(.blue)
              Spacer()
              Text("0")
                .foregroundColor(.gray)
            }
          }
        } header: {
          subtitleHeader("Media Types")
        }
        
        Section {
          NavigationLink(destination: Text("Imports")) {
            HStack {
              Label("Imports", systemImage: "square.and.arrow.down")
                .foregroundColor(.blue)
              Spacer()
              Text("0")
                .foregroundColor(.gray)
            }
          }
          
          NavigationLink(destination: Text("Duplicates")) {
            HStack {
              Label("Duplicates", systemImage: "rectangle.on.rectangle")
                .foregroundColor(.blue)
              Spacer()
              Text("0")
                .foregroundColor(.gray)
            }
          }
          
          NavigationLink(destination: Text("Hidden")) {
            HStack {
              Label("Hidden", systemImage: "eye.slash")
                .foregroundColor(.blue)
              Spacer()
              Image(systemName: "lock.fill")
                .foregroundColor(.gray)
            }
          }
          
          NavigationLink(destination: Text("Recently Deleted")) {
            HStack {
              Label("Recently Deleted", systemImage: "trash.fill")
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
