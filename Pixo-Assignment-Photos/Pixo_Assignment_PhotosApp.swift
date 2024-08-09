//
//  Pixo_Assignment_PhotosApp.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/6/24.
//

import SwiftUI

@main
struct Pixo_Assignment_PhotosApp: App {
  let persistenceController = PersistenceController.shared
  
  var photosViewModel = PhotosListViewModel()
  
  var body: some Scene {
    WindowGroup {
      // CoreDataExampleContentView()
      //     .environment(\.managedObjectContext, persistenceController.container.viewContext)
      TabBarView()
    }
  }
}
