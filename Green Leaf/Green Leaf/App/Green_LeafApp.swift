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
    @State private var showSplash = true
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView()  // Zeige den Splash-Screen
                        .transition(.opacity)
                } else {
                    ContentView()
                        .environmentObject(viewModel)
                        .environmentObject(photoDetailViewModel)
                }
            }
            .onAppear {
                // Prüfe, ob ein Benutzer angemeldet ist oder ein Gast
                Task {
                    await viewModel.fetchUser()  // Überprüfe Benutzer während des Splash-Screens
                }
                
                // Splash-Screen nach 2 Sekunden ausblenden
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
        }
    }
}
