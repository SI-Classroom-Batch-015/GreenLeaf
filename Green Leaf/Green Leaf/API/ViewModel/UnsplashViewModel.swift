//
//  UnsplashViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 24.09.24.
//

import SwiftUI

@MainActor
class UnsplashViewModel: ObservableObject {
    @Published var photos: [UnsplashPhoto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository = UnsplashRepository()
    
    
    func loadPhotos(page: Int = 1) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedPhotos = try await repository.fetchPhotos(page: page)
            photos = fetchedPhotos
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

   }
