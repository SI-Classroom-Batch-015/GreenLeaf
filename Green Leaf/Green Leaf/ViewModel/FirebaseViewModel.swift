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

@MainActor
class FirebaseViewModel: ObservableObject {
    
    // Instanz von FirebaseManager
    private let firebaseManager = FirebaseManager.shared
    
    @Published var userSession: FirebaseAuth.User? // Überwacht, ob ein Benutzer angemeldet ist
    @Published var currentUser: User? // Enthält die aktuellen Benutzerdaten
    
    init(){
        self.userSession = FirebaseManager.shared.auth.currentUser // Aktuellen Benutzer beim Start prüfen
        Task {
            await fetchUser() // Benutzerdaten laden, falls ein Benutzer angemeldet ist
        }
    }
    
    // Login-Methode
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await FirebaseManager.shared.auth.signIn(withEmail: email, password: password)
            self.userSession = result.user // Aktualisiere die userSession
            await fetchUser() // Benutzerdaten laden
        } catch {
            print("Fehler bei der Anmeldung: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Registrierungsmethode
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
           do {
               let result = try await FirebaseManager.shared.auth.createUser(withEmail: email, password: password)
               self.userSession = result.user // Benutzer-Session aktualisieren
               
               // Benutzer-Daten vorbereiten
               let userData: [String: Any] = [
                   "id": result.user.uid,
                   "fullname": fullName,
                   "email": email
               ]
               
               // Benutzerdaten in Firestore speichern
               try await FirebaseManager.shared.database.collection("users").document(result.user.uid).setData(userData)
               
               // Benutzer-Daten abrufen und setzen
               await fetchUser()
               
           } catch {
               print("Fehler bei der Registrierung: \(error.localizedDescription)")
               throw error
           }
       }
    // Methode zum Abrufen der Benutzerdaten
    func fetchUser() async {
        guard let uid = firebaseManager.auth.currentUser?.uid else { return }
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
            try firebaseManager.auth.signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Fehler beim Abmelden: \(error.localizedDescription)")
        }
    }
}
