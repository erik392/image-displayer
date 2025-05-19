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
    
    private func loadImage() {
        Task {
            if let photosPickerItem,
               let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                if let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
            photosPickerItem = nil
        }
    }
}
