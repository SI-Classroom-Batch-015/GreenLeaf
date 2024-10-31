//
//  FirebaseViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 19.09.24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@MainActor
class FirebaseViewModel: ObservableObject {
    
    private let firebaseManager = FirebaseManager.shared
    
    @Published var userSession: FirebaseAuth.User? // Überwacht, ob ein Benutzer angemeldet ist
    @Published var currentUser: User? // Enthält die aktuellen Benutzerdaten
    @Published var isGuest = false // Zustand für Gastnutzung
    @Published var userPhotos: [UnsplashPhoto] = [] // Für Benutzer-Uploads
    @Published var hasSkippedStartup = false
    
    
    
    init() {
        Task {
            await checkUserSession()
        }
    }
    

    
    // Prüft die vorhandene Sitzung beim Start
    private func checkUserSession() async {
        if let currentUser = firebaseManager.auth.currentUser {
            self.userSession = currentUser
            await fetchUser() // Läd die Benutzerdaten für eine vorhandene Sitzung
            hasSkippedStartup = true
        }
    }

    // Gastmodus aktivieren
    func continueAsGuest() {
        isGuest = true
        hasSkippedStartup = true
        userSession = nil
    }
    
    // Login-Methode
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await firebaseManager.auth.signIn(withEmail: email, password: password)
            self.userSession = result.user // Aktualisiere die userSession
            await fetchUser() // Benutzerdaten laden
            
            isGuest = false // Kein Gast mehr
            hasSkippedStartup = true // Start-Bildschirm überspringen
        } catch {
            print("Fehler bei der Anmeldung: \(error.localizedDescription)")
            throw error
        }
    }

    // Registrierungsmethode
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            let result = try await firebaseManager.auth.createUser(withEmail: email, password: password)
            self.userSession = result.user // Benutzer-Session aktualisieren
            
            // Benuzer-Daten vorbereiten
            let userData: [String: Any] = [
                "id": result.user.uid,
                "fullname": fullName,
                "email": email
            ]
            
            // Benutzerdaten in Firestore speichern
            try await firebaseManager.database.collection("users").document(result.user.uid).setData(userData)
            
            // Benutzer-Daten abrufen und setzen
            await fetchUser()
            isGuest = false
            hasSkippedStartup = true
            
        } catch {
            print("Fehler bei der Registrierung: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Methode zum Abrufen der Benutzerdaten
    func fetchUser() async {
        guard let uid = firebaseManager.auth.currentUser?.uid else {
            userSession = nil
            return
        }
        do {
            let snapshot = try await firebaseManager.database.collection("users").document(uid).getDocument()
            if let data = snapshot.data() {
                self.currentUser = User(id: data["id"] as? String ?? "", fullname: data["fullname"] as? String ?? "", email: data["email"] as? String ?? "")
            }
        } catch {
            print("Fehler beim Abrufen des Benutzers: \(error.localizedDescription)")
        }
    }
  

    // Abmeldungsmethode
    func signOut() {
        do {
            try firebaseManager.auth.signOut() // Sign-out in Firebase
            self.userSession = nil // Benutzer-Sitzung zurücksetzen
            self.currentUser = nil // Benutzerdaten zurücksetzen
            isGuest = false // Gastmodus deaktivieren
            hasSkippedStartup = false // Zurück zum Startup-Flow
        } catch {
            print("Fehler beim Abmelden: \(error.localizedDescription)")
        }
    }
}
