//
//  FavoriteView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var viewModel: PhotoDetailViewModel
    
    var body: some View {
        NavigationStack {
            if viewModel.favoritePhotos.isEmpty {
                Text("Keine Favoriten")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.favoritePhotos) { photo in
                            VStack {
                                AsyncImage(url: URL(string: photo.urls.small)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } placeholder: {
                                    ProgressView()
                                }
                                Text(photo.description ?? "Keine Beschreibung")
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.removeFavorite(photo: photo) // Entfernt das Foto als Favorit und löscht es in Firebase
                                } label: {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("Favoriten")
            }
        }
    }
}

#Preview {
    FavoriteView()
        .environmentObject(PhotoDetailViewModel())
}
