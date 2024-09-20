//
//  AuthViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 19.09.24.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthViewModel: ObservableObject {
    
    private var auth = Auth.auth()
    
    @Published var currentUser: User?
    
    @Published var firebaseUser: FirebaseAuth.User?
    @Published var errorMessage: String?
    
    @Published var email = ""
    @Published var password = ""
    
    @Published  var fullName = ""
    @Published  var confirmPassword = ""
    
    init(){
       loadCurrentUser()
    }
    
    func loadCurrentUser() {
            guard let firebaseUser = auth.currentUser else { return }
       
        self.currentUser = User( id: "", fullname: firebaseUser.displayName ?? "", email: firebaseUser.email ?? "")
        }
    
    
    private func checkAuth() {
        guard let currentUser = auth.currentUser else {
            print("Not logged in")
            return
        }
        
        self.firebaseUser = currentUser
    }

    //Login
    func signIn( ){
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                print("login faild:", error.localizedDescription)
                return
            }
            guard let authResult, let email = authResult.user.email else { return }
            print("User with email'\(email)'is logged in with id '\(authResult.user.uid)'")
            self.firebaseUser = authResult.user
            self.errorMessage = nil
        }
      
    }
    
    //signUP
    func register() {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print("Registration failed:", error.localizedDescription)
                return
            }
            
            guard let authResult, let email = authResult.user.email else { return }
            print("User with email '\(email)' is registered with id '\(authResult.user.uid)'")
            
            self.firebaseUser = authResult.user
        }
    }
    //signout
    func signOut(){
        do {
            try auth.signOut()
            self.firebaseUser = nil
            
            print("User wurde abgemeldet!")
        } catch {
            print("Error signing out: ", error.localizedDescription)
        }
        
    }
    
    func deleteAccount(){
        
        
    }
    
    func fetchUser() async {
        
        
    }
    
}
