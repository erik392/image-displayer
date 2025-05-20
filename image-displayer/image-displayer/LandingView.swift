//
//  LandingView.swift
//  image-displayer
//
//  Created by Erik Egers on 2025/05/19.
//

import SwiftUI
import PhotosUI

struct LandingView: View {
    
    // In SwiftUI, we observe the published properties in the view model, and when they change, we update the UI accordingly. We don't rely on the delegate patttern like in UIKit.
    // When using MVVM, it allows for much easier testing of business logic.
    // Also with SwifUI, MVVM is much cleaner than MVC. The view becomes too busy with MVC.
    
    @ObservedObject var viewModel = LandingViewModel(imageLoader: ImageLoader())
    
    var body: some View {
        VStack {
            Image(uiImage: viewModel.selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 400, alignment: .topLeading)
                .foregroundStyle(.tint)
            PhotosPicker(selection: $viewModel.photosPickerItem, matching: .images) {
                Label("Select Image", systemImage: "photo")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .alert("Error", isPresented: $viewModel.showErrorAlert, actions: {
            Button("OK") {
                viewModel.clearError()
            }
        }, message: {
            Text(viewModel.imageLoadingError ?? "")
        })
    }
}

// This specfies how we want our preview of the screen in the right pane to look.
#Preview {
    LandingView()
}
