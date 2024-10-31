//
//  AddPhotoViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 29.10.24.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import PhotosUI
import Combine

@MainActor
class AddPhotoViewModel: ObservableObject {
    @Published var selectedImageItem: PhotosPickerItem? // Verwende PhotosPickerItem
    @Published var selectedImage: UIImage? // Beibehalten für das Bild selbst
    @Published var description = ""
    @Published var isUploading = false
    private var cancellables = Set<AnyCancellable>() // Hinzufügen für Combine

    
    init() {
        $selectedImageItem
            .compactMap { $0 }
            .sink { [weak self] item in
                Task { await self?.loadImage(from: item) }
            }
            .store(in: &cancellables)
    }

    func uploadPhoto() async {
        guard let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        // Hole die aktuelle Benutzer-ID
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        // Erstelle den Pfad mit userId und photoID
        let photoID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("user_photos/\(userId)/\(photoID).jpg")
        
        do {
            // Lade das Bild in Firebase Storage hoch
            _ = try await storageRef.putDataAsync(imageData)
            let downloadURL = try await storageRef.downloadURL()
            
            // Speichere die Metadaten des Fotos in Firestore
            let photoData: [String: Any] = [
                "url": downloadURL.absoluteString,
                "description": description,
                "uploadedAt": FieldValue.serverTimestamp(),
                "userId": userId
            ]
            try await Firestore.firestore().collection("photos").document(photoID).setData(photoData)
            
            print("Foto erfolgreich hochgeladen")
            clearForm()
        } catch {
            print("Fehler beim Hochladen des Fotos: \(error)")
        }
    }


    
    private func clearForm() {
        selectedImageItem = nil
        selectedImage = nil
        description = ""
        isUploading = false
    }
    
    private func loadImage(from item: PhotosPickerItem) async {
        do {
            if let data = try await item.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                selectedImage = image
            }
        } catch {
            print("Fehler beim Laden des Bildes: \(error)")
        }
    }
}
