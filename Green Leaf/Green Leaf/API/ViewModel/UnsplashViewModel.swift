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
    

    var photos: [UnsplashPhoto] = []
    var isLoading = false
    var errorMessage: String?
    
    var searchText: String = "" {
           didSet {
               Task {
                   await handleSearchTextChange(searchText)
               }
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
    
 
    func loadPhotos() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedPhotos = try await repository.fetchPhotos(totalPhotos: 1000)
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
