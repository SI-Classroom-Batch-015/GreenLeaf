//
//  TrendingViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 30.10.24.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class TrendingViewModel: ObservableObject {
    @Published var carouselPhotos: [UnsplashPhoto] = []
    @Published var categoryPhotos: [String: [UnsplashPhoto]] = [:]
    
    private let unsplashRepository = UnsplashRepository()
    
    init() {
        Task {
            await loadTrendingPhotos()
        }
    }
    
    func loadTrendingPhotos() async {
        // Beispiel: Lade Bilder für das Carousel
        do {
            let photos = try await unsplashRepository.searchPhotos(query: "W124")
            self.carouselPhotos = Array(photos.prefix(10)) // Lade nur 10 Fotos für das Carousel
        } catch {
            print("Fehler beim Laden der Carousel-Fotos: \(error)")
        }
        
        // Beispiel für Kategorien
        await loadCategoryPhotos(query: "The Joker", category: "The Joker")
        await loadCategoryPhotos(query: " Hamburg", category: " Hamburg")
        await loadCategoryPhotos(query: "Uk drill", category: "Uk drill")
    }
    
    private func loadCategoryPhotos(query: String, category: String) async {
        do {
            let photos = try await unsplashRepository.searchPhotos(query: query)
            self.categoryPhotos[category] = Array(photos.prefix(10)) // Lade nur 10 Fotos pro Kategorie
        } catch {
            print("Fehler beim Laden der Kategorie-Fotos: \(error)")
        }
    }
}
