//
//  DetailView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/8/24.
//

import SwiftUI

struct DetailView: View {
  @Environment(\.dismiss) var dismiss
  let asset: LibraryImage
  
  @State private var currentZoom = 0.0
  @State private var totalZoom = 1.0
  
  var body: some View {
    VStack {
      PhotoDetailRepresentedView {
        Image(uiImage: asset.image ?? .sample1)
          .resizable()
          .scaledToFit()
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .principal) {
        VStack {
          Text(dateDescription)
            .font(.system(size: 16))
          Text(timeDescription)
            .font(.system(size: 11))
        }
      }
    }
  }
  
  var dateDescription: String {
    let date = asset.creationDate
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
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.dateFormat = "a h:mm"
    
    return formatter.string(from: asset.creationDate)
  }
}

#Preview {
  NavigationView {
    DetailView(asset: .init(id: "Test1", name: "풍경", image: .init(resource: .sample1), creationDate: .now, phAsset: nil))
  }
}
