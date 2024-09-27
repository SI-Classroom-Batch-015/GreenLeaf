//
//  UnsplashPhoto.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 24.09.24.
//

import Foundation

struct UnsplashPhoto: Identifiable, Decodable {
    var id: String
    var description: String?
    var urls: URLs
    var likes: Int
    
    struct URLs: Decodable {
        var small: String
        var full: String
    }
}
