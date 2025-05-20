//
//  LandingViewModel.swift
//  image-displayer
//
//  Created by Erik Egers on 2025/05/19.
//

import SwiftUI
import PhotosUI

@MainActor // This ensures that UI updates happen on the main thread
class LandingViewModel: ObservableObject {
    
    @Published var showErrorAlert: Bool = false
    @Published var imageLoadingError: String? = nil
    @Published var selectedImage: UIImage = UIImage(named: "placeholderImage") ?? UIImage()
    @Published var photosPickerItem: PhotosPickerItem? = nil {
        didSet {
            loadImage() // When an image is selected, we try to load that image
        }
    }
    
    // We use dependency injection here so that we can inject a mock of this image loader in our unit tests
    private let imageLoader: ImageLoading
    
    init(imageLoader: ImageLoading) {
        self.imageLoader = imageLoader
    }
    
    func clearError() {
        // After the user dismisses the error the showErrorAlert should automatically be set to false again.
        // But the error string is not cleared so we do it manually here
        imageLoadingError = nil
    }
    
    private func loadImage() {
        Task {
            if let photosPickerItem {
                do {
                    selectedImage = try await imageLoader.loadImage(from: photosPickerItem)
                } catch {
                    // If there is an error, we display an alert, and once the user dismisses it, they can try again.
                    imageLoadingError = String(format: "Image loading failed: %@", error.localizedDescription)
                    showErrorAlert = true
                }
            }
            photosPickerItem = nil // We reset the picker item to nil such that when the user goes to select a new image, the old one is not pre-selected
        }
    }
}
