//
//  ContentView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 12.09.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainTabView() // Benutzer ist angemeldet, gehe zur Hauptansicht
            } else {
                LoginView() // Benutzer ist nicht angemeldet, zeige die Login-Ansicht
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchUser() // Benutzerdaten laden, wenn die Ansicht erscheint
            }
        }
    }
}
