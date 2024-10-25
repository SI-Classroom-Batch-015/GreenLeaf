//
//  FavoriteView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var viewModel: PhotoDetailViewModel
    @State private var selectedPhoto: UnsplashPhoto?
    
    var body: some View {
        NavigationStack {
            if viewModel.favoritePhotos.isEmpty {
                VStack {
                    Image(systemName: "heart.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    
                    Text("Keine Favoriten")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                }
                .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.favoritePhotos) { photo in
                            VStack {
                                Button(action: {
                                    selectedPhoto = photo // Foto auswählen und im Sheet anzeigen
                                }) {
                                    AsyncImage(url: URL(string: photo.urls.small)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150) // Größe des Thumbnails
                                            .clipped()
                                            .cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 150, height: 150)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                }
                                
                                Text(photo.description ?? "Keine Beschreibung")
                                    .font(.caption)
                                    .lineLimit(1)
                                    .padding(.top, 5)
                            }
                            .contextMenu { // Kontextmenü für das Löschen
                                Button(role: .destructive) {
                                    viewModel.removeFavorite(photo: photo)
                                } label: {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Favoriten")
                .sheet(item: $selectedPhoto) { photo in // Sheet für die Detailansicht des Fotos
                    PhotoDetailSheetView(photo: photo)
                        .environmentObject(viewModel)
                }
            }
        }
    }
}

#Preview {
    FavoriteView()
        .environmentObject(PhotoDetailViewModel())
}
