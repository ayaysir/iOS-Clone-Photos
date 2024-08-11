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
  
  var body: some View {
    ZStack {
      if detailReprViewModel.isFullscreen {
        Color.black.ignoresSafeArea()
      } else {
        Color.white.ignoresSafeArea()
      }
      
      VStack {
        PhotoDetailRepresentedView(viewModel: detailReprViewModel) {
          Image(uiImage: (viewModel.highResImage ?? viewModel.asset.image) ?? .sample1)
            .resizable()
            .scaledToFit()
        }
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
        }
      }
    }
    .onTapGesture {
      detailReprViewModel.isFullscreen.toggle()
    }
    .task {
      if viewModel.highResImage == nil,
         let phAsset = viewModel.asset.phAsset {
        viewModel.highResImage = await loadHighResImage(of: phAsset)
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
        return "오늘"
      } else if calendar.isDateInYesterday(date) {
        return "어제"
      } else if calendar.isDateInWeekend(date) {
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
      }
      
      // 올해인 경우 날짜만 표시
      formatter.dateFormat = "M월 d일"
      return formatter.string(from: date)
    }
    
    // 올해가 아닌 경우 연도도 표시
    formatter.dateFormat = "yyyy년 M월 d일"
    return formatter.string(from: date)
  }
  
  var timeDescription: String {
    let date = viewModel.asset.creationDate
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.dateFormat = "a h:mm"
    
    return formatter.string(from: date)
  }
}

#Preview {
  NavigationView {
    DetailView(
      viewModel: .init(
        asset: .init(id: "Test1",
                     name: "풍경",
                     image: .sample1,
                     creationDate: .now,
                     phAsset: nil)))
  }
}
