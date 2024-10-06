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
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
                    VStack {
                        // Search Bar
                        HStack {
                            // Search Text Field
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("Suche photos...", text: $searchText)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .focused($isSearchFieldFocused)
                                    .onChange(of: searchText) { newValue in
                                        Task {
                                            if !newValue.isEmpty {
                                                await viewModel.searchPhotos(query: newValue) // Startet die Suche, wenn das Suchfeld Text enthält
                                            } else {
                                                await viewModel.loadPhotos() // Lädt Standardfotos, wenn das Suchfeld leer ist
                                            }
                                        }
                                    }

                                
                                // "X" Icon for clearing the text
                                if !searchText.isEmpty {
                                    Button {
                                        searchText = ""
                                        isSearchFieldFocused = true // Keeps the field focused after clearing
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .frame(height: 40)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                            // Cancel Button
                            if isSearchFieldFocused {
                                Button("Cancel") {
                                    isSearchFieldFocused = false // Dismiss the keyboard and unfocus field
                                    searchText = "" // Clear the search text
                                }
                                .foregroundColor(.blue)
                                .padding(.trailing, 10)
                            }
                        }
                        .padding()
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
