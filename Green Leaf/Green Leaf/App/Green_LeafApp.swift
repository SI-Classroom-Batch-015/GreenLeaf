//
//  Green_LeafApp.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 12.09.24.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct Green_LeafApp: App {
    @StateObject var viewModel = FirebaseViewModel()
    @StateObject var photoDetailViewModel = PhotoDetailViewModel()
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(photoDetailViewModel)
        }
    }
}
