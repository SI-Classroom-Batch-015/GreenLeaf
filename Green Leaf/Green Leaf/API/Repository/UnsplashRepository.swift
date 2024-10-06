//
//  UnsplashRepository.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 24.09.24.
//

import Foundation

class UnsplashRepository {
    
    
    func fetchPhotos(page: Int = 1, perPage: Int = 30, orderBy: String = "latest") async throws -> [UnsplashPhoto] {
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)&per_page=\(perPage)&order_by=\(orderBy)&client_id=\(APIKeys.UnsplashAPIKey)") else {
            throw HTTPError.invalidURL
        }
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
       
        let photos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
        
        return photos
    }
    func searchPhotos(query: String) async throws -> [UnsplashPhoto] {
        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "https://api.unsplash.com/search/photos?query=\(searchQuery)&client_id=\(APIKeys.UnsplashAPIKey)") else {
            throw HTTPError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let searchResult = try JSONDecoder().decode(UnsplashSearchResult.self, from: data)
        return searchResult.results
    }

}