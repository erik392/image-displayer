//
//  ContentView.swift
//  image-displayer
//
//  Created by Erik Egers on 2025/05/19.
//

import SwiftUI
import PhotosUI

struct LandingView: View {
    
    @State private var myimage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            Image(uiImage: myimage ?? UIImage(named: "placeholderImage") ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 400, alignment: .topLeading)
                .foregroundStyle(.tint)
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                Label("Select Image", systemImage: "photo")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
            }
        }
        .padding()
        .onChange(of: photosPickerItem) { _, _ in
            Task {
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        myimage = image
                    }
                }
                photosPickerItem = nil
            }
        }
    }
}

#Preview {
    LandingView()
}
