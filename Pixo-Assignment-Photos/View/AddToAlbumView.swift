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
                  Text("새로운 앨범...")
                }
              }
              .buttonStyle(PlainButtonStyle())
            }
          }
          
          Text("나의 앨범")
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
              Text("1장의 사진")
                .foregroundStyle(.foreground)
            }
          }
        }
        .headerProminence(.increased)
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
      .alert("새로운 앨범", isPresented: $showNewAlbumInputAlert) {
        TextField("제목", text: $newAlbumTitle)
        Button("취소", role: .cancel) {
          newAlbumTitle = ""
        }
        Button("저장") {
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
        Text("이 앨범의 이름을 입력하십시오.")
      }
      .alert("앨범에 사진 넣기", isPresented: $showResultAlert) {
        Button("확인") {
          dismiss()
        }
      } message: {
        Text(inputResult ? "앨범에 사진이 추가되었습니다." : "앨범에 사진이 추가되지 않았습니다.")
      }
      .alert("앨범 생성 실패", isPresented: $showCreateAlbumAlert) {
        Button("확인") {}
      } message: {
        Text("앨범에 생성되지 않았습니다.")
      }
    }
  }
}

#Preview {
  AddToAlbumView(viewModel: .init(selectedPhoto: .init(id: "Test1", name: "photo", creationDate: .now, phAsset: nil)))
}
