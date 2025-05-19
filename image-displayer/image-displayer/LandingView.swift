//
//  LandingView.swift
//  image-displayer
//
//  Created by Erik Egers on 2025/05/19.
//

import SwiftUI
import PhotosUI

struct LandingView: View {
    
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
    }
}

#Preview {
    LandingView()
}
