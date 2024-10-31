//
//  PhotoFilter.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 29.10.24.
//

import Foundation

enum PhotoFilter: String, CaseIterable, Identifiable {
    case all = "All Photos"
    case unsplash = "Unsplash Photos"
    case user = "User Photos"
    
    var id: String { self.rawValue }
}
