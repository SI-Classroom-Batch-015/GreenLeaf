//
//  UnsplashRepository.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 24.09.24.
//

import Foundation

class UnsplashRepository {
    
    
    func fetchPhotos(totalPhotos: Int = 1000, orderBy: String = "latest") async throws -> [UnsplashPhoto] {
         var allPhotos: [UnsplashPhoto] = []
         var currentPage = 1
         let perPage = 30
         
         // Schleife, um mehrere Seiten abzufragen
         while allPhotos.count < totalPhotos {
             let photos = try await fetchPhotosPage(page: currentPage, perPage: perPage, orderBy: orderBy)
             allPhotos.append(contentsOf: photos)
             
             // Beende, falls weniger als `perPage`-Einträge zurückgegeben werden
             if photos.count < perPage { break }
             
             currentPage += 1
         }
         
         return Array(allPhotos.prefix(totalPhotos)) // Beschränke auf `totalPhotos`
     }

    private func fetchPhotosPage(page: Int, perPage: Int, orderBy: String) async throws -> [UnsplashPhoto] {
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)&per_page=\(perPage)&order_by=\(orderBy)&client_id=\(APIKeys.UnsplashAPIKey)") else {
            throw HTTPError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            guard httpResponse.statusCode == 200 else {
                throw HTTPError.statusCodeError(httpResponse.statusCode)
            }
        }
        
        do {
            return try JSONDecoder().decode([UnsplashPhoto].self, from: data)
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received data: \(jsonString)")
            }
            throw error
        }
    }

    func searchPhotos(query: String) async throws -> [UnsplashPhoto] {
        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query

        guard let url = URL(string: "https://api.unsplash.com/search/photos?query=\(searchQuery)&client_id=\(APIKeys.UnsplashAPIKey)") else {
            throw HTTPError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let searchResult = try JSONDecoder().decode(UnsplashSearchResult.self, from: data)
        print("Fotos für '\(query)' gefunden: \(searchResult.results.count)")
        return searchResult.results
    }


}


