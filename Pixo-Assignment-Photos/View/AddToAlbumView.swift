//
//  AddToAlbumView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/12/24.
//

import SwiftUI

struct AddToAlbumView: View {
  @Environment(\.dismiss) var dismiss
  
  @StateObject var viewModel: AddToAlbumsViewModel
  
  @State private var showNewAlbumInputAlert = false
  @State private var showResultAlert = false
  @State private var showCreateAlbumAlert = false
  
  @State private var inputResult = false
  @State private var newAlbumTitle = ""
  
  let albumGridSpacing: CGFloat = 15
  
  var body: some View {
    NavigationView {
      List {
        Section {
          VStack {
            LazyVGrid(columns: gridFlexibleColumns(2), spacing: albumGridSpacing) {
              Button {
                showNewAlbumInputAlert.toggle()
              } label: {
                VStack {
                  Image(.emptyAlbum)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                  Text("New Album...")
                }
              }
              .buttonStyle(PlainButtonStyle())
            }
          }
          
          Text("My Albums")
            .font(.headline)
          
          LazyVGrid(columns: gridFlexibleColumns(2), spacing: albumGridSpacing) {
            ForEach(viewModel.albums) { data in
              Button {
                Task {
                  inputResult = await viewModel.addToAlbum(asset: viewModel.selectedPhoto, to: data)
                  showResultAlert = true
                  viewModel.publishAlbumUpdated()
                }
              } label: {
                AlbumCellView(data: data)
              }
              .buttonStyle(PlainButtonStyle())
            }
          }
        } header: {
          VStack {
            HStack {
              Image(uiImage: viewModel.selectedPhoto.image ?? .emptyAlbum)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                  width: 50,
                  height: 40
                )
                .clipped()
              Text("1 Photo")
                .foregroundStyle(.foreground)
            }
          }
        }
        .headerProminence(.increased)
      }
      .listStyle(.inset)
      .navigationTitle("Add to Album")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Cancel") {
            dismiss()
          }
        }
      }
      .alert("New Album", isPresented: $showNewAlbumInputAlert) {
        TextField("Title", text: $newAlbumTitle)
        Button("Cancel", role: .cancel) {
          newAlbumTitle = ""
        }
        Button("Save") {
          Task {
            if await viewModel.createNewAlbum(title: newAlbumTitle) {
              viewModel.publishAlbumUpdated()
            } else {
              showCreateAlbumAlert = true
            }
            
            newAlbumTitle = ""
          }
        }
      } message: {
        Text("Enter a name for this album.")
      }
      .alert("Add Photos to Album", isPresented: $showResultAlert) {
        Button("OK") {
          dismiss()
        }
      } message: {
        Text(inputResult ? "Photos have been added to the album." : "No photos were added to the album.")
      }
      .alert("Album Creation Failed", isPresented: $showCreateAlbumAlert) {
        Button("OK") {}
      } message: {
        Text("Not created in album.")
      }
    }
  }
}

#Preview {
  AddToAlbumView(viewModel: .init(selectedPhoto: .init(id: "Test1", name: "photo", creationDate: .now, phAsset: nil)))
}
