//
//  PhotoDetailsSheetViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 07.10.24.
//

import Foundation
import PhotosUI
@MainActor
class PhotoDetailViewModel: ObservableObject {
    
    func downloadAndSaveImage(from urlString: String) { // übernimmt das gesammte prozess von herunterladen
        guard let url = URL(string: urlString) else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    saveImageToLibrary(image)
                }
            } catch {
                print("Download failed: \(error.localizedDescription)")
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
