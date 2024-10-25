//
//  ProfileView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: FirebaseViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text( user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                Section("General") {
                    HStack {
                        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                        Spacer()
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Section("Account") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                    
                    
                    Button(action: {
                        
                        print("Delete account")
                    }) {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                    }
                }
            }
        } else {
            Text("Keine Benutzerdaten verfügbar")
                .onAppear {
                    Task {
                        await viewModel.fetchUser()
                    }
                }
        }
    }
}

// Preview
#Preview {

        let testViewModel = FirebaseViewModel()
    testViewModel.currentUser = User(id: "1", fullname: "Test USer", email: "test@mail.com")
        
       return ProfileView().environmentObject(testViewModel)
    }
    

