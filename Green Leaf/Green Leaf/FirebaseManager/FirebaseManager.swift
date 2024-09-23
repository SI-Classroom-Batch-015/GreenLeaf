//
//  FirebaseManager.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 23.09.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    let auth = Auth.auth()
    let database = Firestore.firestore()
    
    var userId: String? {
        auth.currentUser?.uid
    }
  
 }

