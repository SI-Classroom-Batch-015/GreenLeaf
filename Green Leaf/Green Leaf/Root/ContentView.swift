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
                ProfileView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            Task{
                await viewModel.checkCurrentUser()
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}
