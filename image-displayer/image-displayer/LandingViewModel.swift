//
//  LandingViewModel.swift
//  image-displayer
//
//  Created by Erik Egers on 2025/05/19.
//

import SwiftUI
import PhotosUI

@MainActor
class LandingViewModel: ObservableObject {
    
    @Published var selectedImage: UIImage = UIImage(named: "placeholderImage") ?? UIImage()
    @Published var photosPickerItem: PhotosPickerItem? = nil {
        didSet {
            loadImage()
        }
    }
    
    private let imageLoader: ImageLoading
    
    init(imageLoader: ImageLoading) {
        self.imageLoader = imageLoader
    }
    
    private func loadImage() {
        Task {
            if let photosPickerItem {
                do {
                    selectedImage = try await imageLoader.loadImage(from: photosPickerItem)
                } catch {
                    print("Image loading failed:", error)
                }
            }
            photosPickerItem = nil
        }
    }
}
