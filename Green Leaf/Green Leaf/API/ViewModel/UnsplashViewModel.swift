//
//  UnsplashViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 24.09.24.
//

import SwiftUI
import FirebaseAuth
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
    
    
    // Lädt Fotos aus der Unsplash API und Benutzerfotos aus Firestore
    func loadPhotos() async {
        isLoading = true
        errorMessage = nil
        do {
            async let fetchedPhotos = repository.fetchPhotos(totalPhotos: 1000, orderBy: "latest")
            async let fetchedUserPhotos = fetchUserPhotos()
            
            photos = try await fetchedPhotos
            userPhotos = try await fetchedUserPhotos
            
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
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Authentication", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let snapshot = try await firebaseManager.database.collection("photos")
            .whereField("userId", isEqualTo: userId)
            .order(by: "uploadedAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> UnsplashPhoto? in
            guard let url = doc["url"] as? String else { return nil }
            return UnsplashPhoto(id: doc.documentID, description: doc["description"] as? String ?? "User Photo", urls: UnsplashPhoto.URLs(small: url, full: url), likes: 0)
        }
    }
    private func fetchUserFavorites() async throws -> [UnsplashPhoto] {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Authentication", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let snapshot = try await firebaseManager.database.collection("users")
            .document(userId)
            .collection("favorites")
            .getDocuments()
        
        return snapshot.documents.compactMap { doc -> UnsplashPhoto? in
            guard let url = doc["url"] as? String else { return nil }
            return UnsplashPhoto(id: doc.documentID, description: doc["description"] as? String ?? "Favorited Photo", urls: UnsplashPhoto.URLs(small: url, full: url), likes: 0)
        }
    }
    
    
    
}
