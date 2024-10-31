//
//  UnsplashViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 24.09.24.
//

import SwiftUI
import Observation

@Observable
class UnsplashViewModel {
    
    private let repository = UnsplashRepository()
    private let firebaseManager = FirebaseManager.shared
    
    // Published properties for the view
    var photos: [UnsplashPhoto] = []
    var userPhotos: [UnsplashPhoto] = []
    var selectedFilter: PhotoFilter = .all
    
    var isLoading = false
    var errorMessage: String?
    
    var searchText: String = "" {
        didSet {
            Task {
                await handleSearchTextChange(searchText)
            }
        }
    }
    
    // Kombinierte und gefilterte Fotos, abhängig vom ausgewählten Filter
    var filteredPhotos: [UnsplashPhoto] {
        switch selectedFilter {
        case .all:
            return userPhotos + photos // Benutzerfotos werden zuerst angezeigt
        case .unsplash:
            return photos
        case .user:
            return userPhotos
        }
    }
    
    
    private func handleSearchTextChange(_ newValue: String) async {
        // Check for debounce conditions
        try? await Task.sleep(nanoseconds: 300 * 1_000_000)
        
        if newValue == searchText { // Verify the text hasn't changed
            if newValue.isEmpty {
                await loadPhotos()
            } else {
                await searchPhotos(query: newValue)
            }
        }
    }
    
    
    // Load initial photos from Unsplash API and Firebase
    func loadPhotos() async {
        isLoading = true
        errorMessage = nil
        do {
            async let fetchedPhotos = repository.fetchPhotos(totalPhotos: 1000, orderBy: "latest")
            async let fetchedUserPhotos = fetchUserPhotos()
            
            photos = try await fetchedPhotos
            userPhotos = try await fetchedUserPhotos
            
            // Aktualisiere gefilterte Fotos, um den neuen Zustand widerzuspiegeln
            if selectedFilter == .all {
                // Wenn "All Photos" aktiv ist, sicherstellen, dass beide Sets angezeigt werden
                photos = photos + userPhotos
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    
    func searchPhotos(query: String) async {
        guard !query.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        do {
            let fetchedPhotos = try await repository.searchPhotos(query: query)
            photos = fetchedPhotos
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    // Fetch user-uploaded photos from Firebase Firestore
    private func fetchUserPhotos() async throws -> [UnsplashPhoto] {
        do {
            let snapshot = try await firebaseManager.database.collection("photos").order(by: "uploadedAt", descending: true).getDocuments()
            return snapshot.documents.compactMap { doc -> UnsplashPhoto? in
                guard let url = doc["url"] as? String else { return nil }
                return UnsplashPhoto(id: doc.documentID, description: doc["description"] as? String ?? "User Photo", urls: UnsplashPhoto.URLs(small: url, full: url), likes: 0)
            }
        } catch {
            print("Fehler beim Laden der Benutzerfotos: \(error)")
            throw error
        }
    }
    
}
