//
//  AddView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI
import PhotosUI

struct AddView: View {
    @StateObject private var viewModel = AddPhotoViewModel()

    var body: some View {
        VStack {
            PhotosPicker("Foto auswählen", selection: $viewModel.selectedImageItem, matching: .images) // Verwende selectedImageItem
                .frame(height: 200)
            
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            TextField("Beschreibung hinzufügen", text: $viewModel.description)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button("Foto hochladen") {
                Task {
                    await viewModel.uploadPhoto()
                }
            }
            .disabled(viewModel.selectedImage == nil || viewModel.isUploading)
            .padding()
        }
        .padding()
    }
}

#Preview {
    AddView()
}
