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
  
  let albumGridSpacing: CGFloat = 15
  
  var body: some View {
    NavigationView {
      List {
        Section {
          LazyVGrid(columns: gridFlexibleColumns(2), spacing: 15) {
            VStack {
              Image(.emptyAlbum)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
              Text("새로운 앨범...")
            }
          }
          
          Text("나의 앨범")
            .font(.headline)
          
          LazyVGrid(columns: gridFlexibleColumns(2), spacing: 15) {
            ForEach(viewModel.albums) { data in
                AlbumCellView(data: data)
              }
          }
        } header: {
          VStack {
            HStack {
              Image(uiImage: viewModel.selectedPhoto.image ?? .emptyAlbum)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 40)
                .clipped()
              Text("1장의 사진")
                .foregroundStyle(.foreground)
            }
          }
        }.headerProminence(.increased)
      }
      .listStyle(.inset)
      .navigationTitle("앨범에 추가")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("취소") {
            dismiss()
          }
        }
      }
    }
  }
}

#Preview {
  AddToAlbumView(viewModel: .init(selectedPhoto: .init(id: "Test1", name: "photo", creationDate: .now, phAsset: nil)))
}
