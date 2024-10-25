//
//  PhotoDetailsSheetView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 07.10.24.
//
import SwiftUI

struct PhotoDetailSheetView: View {
    let photo: UnsplashPhoto
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: PhotoDetailViewModel
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            AsyncImage(url: URL(string: photo.urls.full)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .padding()
            
            Text(photo.description ?? "Keine Beschreibung")
                .font(.headline)
                .padding()
            
            HStack {
                // Favorisieren nur für angemeldete Benutzer möglich
                if !firebaseViewModel.isGuest {
                    Button(action: {
                        viewModel.toggleFavorite(photo: photo, isGuest: firebaseViewModel.isGuest) // Den Gaststatus übergeben
                    }) {
                        Label(viewModel.isFavorite(photo: photo) ? "Entfernen" : "Favorisieren",
                              systemImage: viewModel.isFavorite(photo: photo) ? "heart.slash.fill" : "heart.fill")
                        .foregroundColor(.red)
                    }
                    .padding(.horizontal)
                } else {
                    // Favorisieren für Gäste deaktiviert
                    Label("Favorisieren", systemImage: "heart.fill")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .opacity(0.5) // Visuell zeigen, dass es deaktiviert ist
                }
                Button(action: {
                    viewModel.downloadAndSaveImage(from: photo.urls.full)
                }) {
                    Label("Herunterladen", systemImage: "arrow.down.circle.fill")
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
            }
        }
    }
}
#Preview {
    let examplePhoto = UnsplashPhoto(
        id: "example_id",
        description: "Beispielbild",
        urls: UnsplashPhoto.URLs(
            small: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNjUyOXwwfDF8c2VhcmNofDR8fHRyZWV8ZW58MHx8fHwxNjA4NzY4NzU1&ixlib=rb-1.2.1&q=80&w=400",
            full: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNjUyOXwwfDF8c2VhcmNofDR8fHRyZWV8ZW58MHx8fHwxNjA4NzY4NzU1&ixlib=rb-1.2.1&q=80&w=1080"
        ),
        likes: 123
    )
    
    return PhotoDetailSheetView(photo: examplePhoto)
        .environmentObject(PhotoDetailViewModel())
}
