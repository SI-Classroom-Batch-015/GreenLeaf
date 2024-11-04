//
//  CategorySectionView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 30.10.24.
//


import SwiftUI

struct CategorySectionView: View {
    let title: String
    let photos: [UnsplashPhoto]
    @Binding var selectedPhoto: UnsplashPhoto? // Binding für das ausgewählte Foto
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.leading, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(photos) { photo in
                        AsyncImage(url: URL(string: photo.urls.small)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 150)
                                .clipped()
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedPhoto = photo // Setzt das ausgewählte Foto
                                }
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 100, height: 150)
                                .cornerRadius(10)
                        }
                    }
                }
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
    
    CategorySectionView(title: "Actors", photos: examplePhotos, selectedPhoto: .constant(nil))
}
