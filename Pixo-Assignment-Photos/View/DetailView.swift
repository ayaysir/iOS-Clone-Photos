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
  
  var body: some View {
    VStack {
      Image(uiImage: asset.image)
        .resizable()
        .scaledToFit()
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .principal) {
        VStack {
          Text(dateDescription(for: asset.creationDate))
            .font(.system(size: 16))
          Text("오후 9:42")
            .font(.system(size: 11  ))
        }
      }
    }
  }
  
  func dateDescription(for date: Date) -> String {
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
}

#Preview {
  DetailView(asset: .init(id: "Test1", name: "풍경", image: .init(resource: .sample1), creationDate: .now))
}
