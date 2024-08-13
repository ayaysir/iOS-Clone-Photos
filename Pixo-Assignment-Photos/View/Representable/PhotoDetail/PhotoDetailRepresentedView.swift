//
//  PhotoDetailRepresentedView.swift
//  Pixo-Assignment-Photos
//
//  Created by 윤범태 on 8/10/24.
//

import SwiftUI

struct PhotoDetailRepresentedView<Content: View>: UIViewRepresentable {
  @ObservedObject var viewModel: PhotoDetailRepresentedViewModel
  private var content: Content
  
  init(viewModel: PhotoDetailRepresentedViewModel, @ViewBuilder content: () -> Content) {
    self.viewModel = viewModel
    self.content = content()
  }
  
  func makeUIView(context: Context) -> UIScrollView {
    // set up the UIScrollView
    let scrollView = UIScrollView()
    scrollView.delegate = context.coordinator  // for viewForZooming(in:)
    scrollView.maximumZoomScale = 20
    scrollView.minimumZoomScale = 1
    scrollView.bouncesZoom = true
    
    // create a UIHostingController to hold our SwiftUI content
    let hostedView = context.coordinator.hostingController.view!
    hostedView.translatesAutoresizingMaskIntoConstraints = true
    hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    hostedView.frame = scrollView.bounds
    scrollView.addSubview(hostedView)
    
    return scrollView
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(hostingController: UIHostingController(rootView: self.content), viewModel: viewModel)
  }
  
  func updateUIView(_ uiView: UIScrollView, context: Context) {
    // update the hosting controller's SwiftUI content
    context.coordinator.hostingController.rootView = self.content
    assert(context.coordinator.hostingController.view.superview == uiView)
    // TODO: - 배경 토글시 다크모드 고려
    context.coordinator.hostingController.view!.backgroundColor = viewModel.isFullscreen ? .black : .white
  }
  
  // MARK: - Coordinator
  
  class Coordinator: NSObject, UIScrollViewDelegate {
    var hostingController: UIHostingController<Content>
    var viewModel: PhotoDetailRepresentedViewModel
    
    init(hostingController: UIHostingController<Content>, viewModel: PhotoDetailRepresentedViewModel) {
      self.hostingController = hostingController
      self.viewModel = viewModel
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return hostingController.view
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
      viewModel.currentScale = scale
    }
  }
}

#Preview {
  PhotoDetailRepresentedView(viewModel: .init()) {
    Image(uiImage: .sample1)
  }
}
