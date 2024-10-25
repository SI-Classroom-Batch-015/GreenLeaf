//
//  ContentView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 12.09.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: FirebaseViewModel
    @EnvironmentObject var photoDetailViewModel: PhotoDetailViewModel

    var body: some View {
        NavigationView {
            if viewModel.hasSkippedStartup {
                if viewModel.isGuest || viewModel.userSession != nil {
                    MainTabView() // Navigiere zur Hauptansicht, wenn der Benutzer angemeldet ist oder Gastmodus aktiviert wurde
                        .environmentObject(viewModel)
                        .environmentObject(photoDetailViewModel)
                } else {
                    WelcomeScreenView() // Navigiere zum Willkommensbildschirm, wenn der Benutzer abgemeldet ist
                        .environmentObject(viewModel)
                }
            } else {
                WelcomeScreenView() // Navigiere zum Willkommensbildschirm, wenn der Benutzer noch keinen Login durchgeführt hat
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchUser()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FirebaseViewModel())
        .environmentObject(PhotoDetailViewModel())
}
