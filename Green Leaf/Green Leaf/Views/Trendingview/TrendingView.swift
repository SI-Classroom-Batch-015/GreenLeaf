//
//  TrendingView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct TrendingView: View {
    @StateObject private var viewModel = TrendingViewModel()
    @State private var selectedPhoto: UnsplashPhoto? // Zustand für das ausgewählte Foto
    
    var body: some View {
        NavigationStack {
            VStack {
                // Carousel View oben
                TabView {
                    ForEach(viewModel.carouselPhotos) { photo in
                        AsyncImage(url: URL(string: photo.urls.small)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(15)
                                .onTapGesture {
                                    selectedPhoto = photo
                                }
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                                .cornerRadius(15)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 200)
                .padding(.bottom, 20)
                
                // Kategorien darunter
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.categoryPhotos.keys.sorted(), id: \.self) { category in
                            if let photos = viewModel.categoryPhotos[category] {
                                CategorySectionView(title: category, photos: photos, selectedPhoto: $selectedPhoto)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Trending")
            .sheet(item: $selectedPhoto) { photo in
                PhotoDetailSheetView(photo: photo) // Zeigt die Detailansicht des Fotos an
            }
        }
    }
}
#Preview {
    let examplePhotos = [
        UnsplashPhoto(id: "1", description: "Beispiel 1", urls: UnsplashPhoto.URLs(small: "https://via.placeholder.com/100", full: "https://via.placeholder.com/100"), likes: 10),
        UnsplashPhoto(id: "2", description: "Beispiel 2", urls: UnsplashPhoto.URLs(small: "https://via.placeholder.com/100", full: "https://via.placeholder.com/100"), likes: 15),
        UnsplashPhoto(id: "3", description: "Beispiel 3", urls: UnsplashPhoto.URLs(small: "https://via.placeholder.com/100", full: "https://via.placeholder.com/100"), likes: 20)
    ]
    
    let exampleCategoryPhotos = [
        "Actors": examplePhotos,
        "The Joker": examplePhotos,
        "Tom Hardy": examplePhotos
    ]
    
    let viewModel = TrendingViewModel()
    viewModel.carouselPhotos = examplePhotos
    viewModel.categoryPhotos = exampleCategoryPhotos
    
    return TrendingView()
        .environmentObject(viewModel)
}
