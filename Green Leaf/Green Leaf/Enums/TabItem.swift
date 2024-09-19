//
//  TabItem.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 19.09.24.
//


import Foundation

enum TabItem {
    case home, Add,trending,Favorite,Profil
    
    // Anstatt den Titel jedes Mal einzugeben, können wir diesen in einer Computed Property direkt hier verwalten
    // Das hat zusätzlich den Vorteil, dass dieser bei Änderungen nur an einer Stelle geändert werden muss
    var title: String {
        switch self {
        case .home: return "Entdecken"
        case .trending: return "Trending"
        case .Add: return "Add"
        case .Favorite: return "Favorite"
        case .Profil: return "Profil"
            
        }
    }
    
    // Wir nutzen direkt den Namen des SFSymbols
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .trending: return "flame.fill"
        case .Add: return "camera.viewfinder"
        case .Favorite: return "star.fill"
        case .Profil: return "person.fill"
            
        }
    }
}
