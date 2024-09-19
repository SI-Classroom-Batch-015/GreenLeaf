//
//  Green_LeafApp.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 12.09.24.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct Green_LeafApp: App {
    
    init() {
          FirebaseConfiguration.shared.setLoggerLevel(.min)
          FirebaseApp.configure()
      }
    
    var body: some Scene {
        WindowGroup {
           SplashScreenView()
        }
    }
}
