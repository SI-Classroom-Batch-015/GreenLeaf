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
    @StateObject var viewModel = FirebaseViewModel()
    
    init() {
          FirebaseConfiguration.shared.setLoggerLevel(.min)
          FirebaseApp.configure()
      }
    
    var body: some Scene {
        WindowGroup {
                   if viewModel.userSession != nil {
                       MainTabView().environmentObject(viewModel)
                   } else {
                       SplashScreenView().environmentObject(viewModel)
                   }
               }
           }
       }
