//
//  DetailView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/8/24.
//

import SwiftUI

struct DetailView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: DetailViewModel
  @StateObject var detailReprViewModel: PhotoDetailRepresentedViewModel = .init()
  @EnvironmentObject var photosListViewModel: PhotosListViewModel
  
  @State private var translation: CGSize = .zero
  
  var currentImage: UIImage {
    (viewModel.highResImage ?? viewModel.asset.image) ?? .emptyAlbum
  }
  
  var body: some View {
    ZStack {
      if detailReprViewModel.isFullscreen {
        Color.black.ignoresSafeArea()
      } else {
        Color.white.ignoresSafeArea()
      }
      
      VStack {
        PhotoDetailRepresentedView(viewModel: detailReprViewModel) {
          Image(uiImage: currentImage)
            .resizable()
            .scaledToFit()
        }
        .offset(x: detailReprViewModel.currentScale == 1 ? translation.width : 0)
        .gesture(
          DragGesture()
            .onChanged { value in
              
              translation = value.translation
            }
            .onEnded { value in
              let threshold: CGFloat = 100
              
              if value.translation.width > threshold {
                // Right swipe
                DispatchQueue.main.async {
                  if viewModel.currentIndex > 0 {
                    viewModel.currentIndex -= 1
                  }
                }
              } else if value.translation.width < -threshold {
                // Left swipe
                DispatchQueue.main.async {
                  if viewModel.currentIndex < photosListViewModel.assets.count - 1 {
                    viewModel.currentIndex += 1
                  }
                }
              }
              
              translation = .zero
            }
        )
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(detailReprViewModel.isFullscreen)
    .toolbar {
      ToolbarItem(placement: .principal) {
        if !detailReprViewModel.isFullscreen {
          VStack {
            Text(dateDescription)
              .font(.system(size: 16))
            Text(timeDescription)
              .font(.system(size: 11))
          }
        } else {
          VStack {
            Text(" ")
              .font(.system(size: 16))
            Text(" ")
              .font(.system(size: 11))
          }
        }
      }
    }
    .onTapGesture {
      detailReprViewModel.isFullscreen.toggle()
    }
    .onChange(of: detailReprViewModel.isFullscreen) { newValue in
      if newValue {
        TabBarModifier.hideTabBar()
      } else {
        TabBarModifier.showTabBar()
      }
    }
    .onChange(of: viewModel.currentIndex) { newValue in
      guard newValue >= 0, newValue < photosListViewModel.assets.count else {
        return
      }
      
      let otherImageData = photosListViewModel.assets[newValue]
      viewModel.asset = otherImageData
      
      translation = .zero
      
      Task {
        let image = await viewModel.loadHighResImage()
        DispatchQueue.main.async {
          viewModel.highResImage = image
        }
      }
    }
    .task {
      let image = await viewModel.loadHighResImage()
      DispatchQueue.main.async {
        viewModel.highResImage = image
      }
    }
  }
  
  var dateDescription: String {
    let date = viewModel.asset.creationDate
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.locale = .current
    
    let currentYear = calendar.component(.year, from: .now)
    let dateYear = calendar.component(.year, from: date)
    
    if dateYear == currentYear {
      if calendar.isDateInToday(date) {
        return "Today"
      } else if calendar.isDateInYesterday(date) {
        return "Yesterday"
      } else if calendar.isDateInWeekend(date) {
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
      }
      
      // 올해인 경우 날짜만 표시
      formatter.dateFormat = "MMMM d"
      return formatter.string(from: date)
    }
    
    // 올해가 아닌 경우 연도도 표시
    formatter.dateFormat = "MMMM d, yyyy"
    return formatter.string(from: date)
  }
  
  var timeDescription: String {
    let date = viewModel.asset.creationDate
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.dateFormat = "h:mm a"
    
    return formatter.string(from: date)
  }
}

#Preview {
  NavigationView {
    DetailView(
      viewModel: .init(
        currentIndex: 5,
        asset: .init(id: "Test1",
                     name: "풍경",
                     image: .sample1,
                     creationDate: .now,
                     phAsset: nil)))
    .environmentObject(PhotosListViewModel(listMode: .preview))
  }
}
