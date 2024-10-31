//
//  HomeView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct HomeView: View {
    @Binding var tab: TabItem
    
    @State var viewModel = UnsplashViewModel()
    @EnvironmentObject var photoDetailViewModel: PhotoDetailViewModel
    @FocusState private var isSearchFieldFocused: Bool
    @State private var selectedPhoto: UnsplashPhoto?
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search Bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Suche photos...", text: $viewModel.searchText) // Bind direkt an das ViewModel
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .focused($isSearchFieldFocused) // Fokus-Status
                        
                        // "X" Icon for clearing the text
                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.searchText = "" // Clear the search text
                                isSearchFieldFocused = true // Setze den Fokus erneut
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
                            isSearchFieldFocused = false // Entferne den Fokus
                            viewModel.searchText = "" // Leere den Suchtext
                        }
                        .foregroundColor(.blue)
                        .padding(.trailing, 10)
                    }
                }
                .padding()
                // Filter Picker
                Picker("Filter", selection: $viewModel.selectedFilter) {
                    ForEach(PhotoFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content
                if viewModel.isLoading {
                    
                    ProgressView("Lade Photos")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Fehler: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(viewModel.filteredPhotos) { photo in
                                VStack {
                                    AsyncImage(url: URL(string: photo.urls.small)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .onTapGesture {
                                                selectedPhoto = photo // Öffnet das Detail-Sheet
                                            }
                                    } placeholder: {
                                        ProgressView()
                                        
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
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
            .sheet(item: $selectedPhoto) { photo in
                PhotoDetailSheetView(photo: photo)
            }
            .environmentObject(photoDetailViewModel)
        }
    }
    
}


#Preview {
    HomeView(tab: .constant(.home))
        .environmentObject(PhotoDetailViewModel())
}
