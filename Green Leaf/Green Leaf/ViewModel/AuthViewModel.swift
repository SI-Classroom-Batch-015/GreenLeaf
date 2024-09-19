//
//  AuthViewModel.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 19.09.24.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    
    init(){
        
    }
    
    func signIn(withEmail email: String,password: String )async throws {
        print("signin")
    }
    func creatUSer(withEmail email: String,password: String,fullname:String)async throws {
        print("create user")
    }
    
    func signOut(){
        
    }
    
    func deleteAccount(){
        
    }
    func fetchUser() async {
        
    }
    
}
