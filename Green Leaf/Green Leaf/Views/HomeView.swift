//
//  HomeView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct HomeView: View {
    @Binding var tab: TabItem
    
    @StateObject var viewModel = UnsplashViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Lade Photos")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Fehler: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(viewModel.photos) { photo in
                                VStack {
                                    
                                    AsyncImage(url: URL(string: photo.urls.small)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    
                                    Text(photo.description ?? "Keine Beschreibung")
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Entdecke Fotos")
            .onAppear {
                Task {
                    await viewModel.loadPhotos()
                }
            }
        }
    }
}


#Preview {
    HomeView(tab: .constant(.home))
}
