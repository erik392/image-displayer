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
    
    @Published var showErrorAlert: Bool = false
    @Published var imageLoadingError: String? = nil
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
    
    func clearError() {
        imageLoadingError = nil
    }
    
    private func loadImage() {
        Task {
            if let photosPickerItem {
                do {
                    selectedImage = try await imageLoader.loadImage(from: photosPickerItem)
                } catch {
                    showErrorAlert = true
                    imageLoadingError = String(format: "Image loading failed:", error.localizedDescription)
                }
            }
            photosPickerItem = nil
        }
    }
}
