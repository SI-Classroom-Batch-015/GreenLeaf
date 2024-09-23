//
//  AuthViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 19.09.24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
     
        
        Task{
            await fetchUser()
        }
    }
    
    //Login
    func signIn(withEmail email: String , password:String ) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("DEBUG: Failed to logo in with error \(error.localizedDescription)")
        }
       
        
    }
    
    //signUP
    func createUser(withEmail email: String, password:String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("useres").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
        
        //signout
        func signOut(){
            do {
                try Auth.auth().signOut() // signs out user on backend
                self.userSession = nil // wipes out user session and takes us back to login screen
                self.currentUser = nil // wipes out current user data model
                
            } catch {
                print("DEBUG: faild to sign out with error \(error.localizedDescription)")
                
            }
            
        }
        
        func deleteAccount(){
            
            
        }
        
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No user logged in")
            return
        }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current User is \(self.currentUser)")
    }
    
    func checkCurrentUser() async {
        if Auth.auth().currentUser != nil {
            self.userSession = Auth.auth().currentUser
            await fetchUser()
        } else {
            self.userSession = nil
            self.currentUser = nil
        }
    }


        
  }
    

