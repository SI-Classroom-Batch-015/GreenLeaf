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
        Group {
            if viewModel.userSession != nil {
                MainTabView() // Benutzer ist angemeldet, gehe zur Hauptansicht
                    .environmentObject(viewModel)
                    .environmentObject(photoDetailViewModel)
            } else {
                LoginView() // Benutzer ist nicht angemeldet, zeige die Login-Ansicht
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchUser() // Benutzerdaten laden, wenn die Ansicht erscheint
            }
        }
    }
}
#Preview {
    ContentView()
        .environmentObject(FirebaseViewModel())
        .environmentObject(PhotoDetailViewModel())
}
