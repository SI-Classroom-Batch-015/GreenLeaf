//
//  User.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 19.09.24.
//

import Foundation

struct User: Identifiable,Codable {
    
    let id: String
    let fullname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    
   /* var dictionary: [String: Any] {
           return [
               "id": id,
               "fullname": fullname,
               "email": email
           ]
    */
       }
   }

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname:"Maisam Ahmadi" , email: "test@gmail.com")
}

