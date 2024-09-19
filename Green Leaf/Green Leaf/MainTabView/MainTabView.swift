//
//  MainTabView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView(tab: $selectedTab)
                .tabItem {
                    Label(TabItem.home.title, systemImage: TabItem.home.icon)
                }
                .tag(TabItem.home)
                .badge(10)
            
            TrendingView()
                .tabItem {
                    Label(TabItem.trending.title, systemImage: TabItem.trending.icon)
                }
                .tag(TabItem.trending)
            
           AddView()
                .tabItem {
                    Label(TabItem.Add.title, systemImage: TabItem.Add.icon)
                }
                .tag(TabItem.Add)
            
            FavoriteView()
                 .tabItem {
                     Label(TabItem.Favorite.title, systemImage: TabItem.Favorite.icon)
                 }
                 .tag(TabItem.Favorite)
            
            ProfileView()
                 .tabItem {
                     Label(TabItem.Profil.title, systemImage: TabItem.Profil.icon)
                 }
                 .tag(TabItem.Profil)
        }
        .accentColor(.green) //  Tab Highlight Color
    }
    
}
#Preview {
    MainTabView()
}
 
