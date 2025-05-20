//
//  ImageLoader.swift
//  image-displayer
//
//  Created by Erik Egers on 2025/05/19.
//

import PhotosUI
import SwiftUI

// MARK: - Image Loading Protocol

protocol ImageLoading {
    
    func loadImage(from item: PhotosPickerItem) async throws -> UIImage
}

// MARK: - Image Loading Implementation

struct ImageLoader: ImageLoading {
    
    struct ImageLoadingError: LocalizedError {
        var errorDescription: String? {
            "Technical error when loading image."
        }
    }
    
    func loadImage(from item: PhotosPickerItem) async throws -> UIImage {
        let data = try await item.loadTransferable(type: Data.self)
        guard let data, let image = UIImage(data: data) else {
            throw ImageLoadingError()
        }
        return image
    }
}
