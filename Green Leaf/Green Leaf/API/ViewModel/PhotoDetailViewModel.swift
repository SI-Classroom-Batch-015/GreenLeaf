//
//  PhotoDetailsSheetViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 07.10.24.
//

import Foundation
import PhotosUI
import FirebaseFirestore
import FirebaseAuth
import Firebase

@MainActor
class PhotoDetailViewModel: ObservableObject {
    
    
    private let firebaseManager = FirebaseManager.shared
    @Published var favoritePhotos: [UnsplashPhoto] = []
    @Published var isGuest: Bool = false
    
    init() {
        Task {
            await fetchFavorites()
        }
    }
    
    // Favorisieren nur für angemeldete Benutzer möglich
    func toggleFavorite(photo: UnsplashPhoto, isGuest: Bool) {
        guard !isGuest else {
            print("Favorisieren ist für Gäste nicht erlaubt.")
            return
        }
        
        if isFavorite(photo: photo) {
            removeFavorite(photo: photo)
        } else {
            addFavorite(photo: photo)
        }
    }
    
    
    // Favorit hinzufügen und in Firebase speichern
    func addFavorite(photo: UnsplashPhoto) {
        favoritePhotos.append(photo)
        Task {
            await saveFavoriteToFirebase(photo)
            await fetchFavorites() // Holen Sie sich die neuesten Favoriten nach dem Speichern
        }
    }
    
    // Favorit aus Liste und Firebase löschen
    func removeFavorite(photo: UnsplashPhoto) {
        favoritePhotos.removeAll { $0.id == photo.id }
        Task {
            await deleteFavoriteFromFirebase(photo)
            await fetchFavorites() // Die Favoritenliste nach dem Löschen neu laden
        }
    }
    
    // Prüfen, ob das Foto favorisiert ist
    func isFavorite(photo: UnsplashPhoto) -> Bool {
        favoritePhotos.contains { $0.id == photo.id }
    }
    
    // Favorit in Firebase speichern
    private func saveFavoriteToFirebase(_ photo: UnsplashPhoto) async {
        guard let userId = firebaseManager.userId else { return }
        let favoriteData: [String: Any] = [
            "id": photo.id,
            "description": photo.description ?? "",
            "urls": [
                "small": photo.urls.small,
                "full": photo.urls.full
            ]
        ]
        
        do {
            try await firebaseManager.database
                .collection("users")
                .document(userId)
                .collection("favorites")
                .document(photo.id)
                .setData(favoriteData)
        } catch {
            print("Fehler beim Speichern des Favoriten in Firebase: \(error.localizedDescription)")
        }
    }
    
    // Favorit aus Firebase löschen
    private func deleteFavoriteFromFirebase(_ photo: UnsplashPhoto) async {
        guard let userId = firebaseManager.userId else { return }
        
        do {
            try await firebaseManager.database
                .collection("users")
                .document(userId)
                .collection("favorites")
                .document(photo.id)
                .delete()
        } catch {
            print("Fehler beim Löschen des Favoriten aus Firebase: \(error.localizedDescription)")
        }
    }
    
    // Favoriten aus Firebase laden
    func fetchFavorites() async {
            guard let userId = firebaseManager.userId else {
                favoritePhotos = []
                return
            }
            
            do {
                let snapshot = try await firebaseManager.database
                    .collection("users")
                    .document(userId)
                    .collection("favorites")
                    .getDocuments()
                
                let photos = snapshot.documents.compactMap { doc -> UnsplashPhoto? in
                    let data = doc.data()
                    print("Favoritendaten erhalten: \(data)")
                    guard let id = data["id"] as? String,
                          let urls = data["urls"] as? [String: String],
                          let smallURL = urls["small"],
                          let fullURL = urls["full"] else { return nil }
                    
                    return UnsplashPhoto(
                        id: id,
                        description: data["description"] as? String,
                        urls: UnsplashPhoto.URLs(small: smallURL, full: fullURL),
                        likes: 0
                    )
                }
                self.favoritePhotos = photos
            } catch {
                print("Fehler beim Abrufen der Favoriten aus Firebase: \(error.localizedDescription)")
            }
        }

    
    // _______________________________________________________________________________________//
    
    func downloadAndSaveImage(from urlString: String) { // übernimmt das gesammte prozess von herunterladen
        guard let url = URL(string: urlString) else {
            print("Ungültige URL: \(urlString)")
            return
        }
        
        Task {
            do {
                print("Herunterladen des Bildes von \(urlString) gestartet")
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    print("Bild erfolgreich heruntergeladen, speichere in der Bibliothek")
                    saveImageToLibrary(image)
                } else {
                    print("Fehler: Ungültiges Bildformat")
                }
            } catch {
                print("Download fehlgeschlagen: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func saveImageToLibrary(_ image: UIImage) { // ümmert sich um sicherung zugriff auf die fotobibilothik und die speicherung von bild
        PHPhotoLibrary.shared().performChanges({ // das bild in gallery hinzufügen und dabei wird der Zugriff auf die gallery gewährt.
            PHAssetChangeRequest.creationRequestForAsset(from: image) // inerhalb der closure wird das PHAssetChangeRequest ertellt um das bild in gallery zu speichern
        }, completionHandler: { success, error in // gibt züruck ob die Speicherung erfolgt war oder ob ein fehler aufgeterten ist
            if success {
                print("Image saved successfully")
            } else if let error = error {
                print("Save failed: \(error.localizedDescription)")
            }
        })
    }
    
}

