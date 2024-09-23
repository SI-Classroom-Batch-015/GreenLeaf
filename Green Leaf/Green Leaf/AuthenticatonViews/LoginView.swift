//
//  LoginView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: FirebaseViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(systemName: "camera.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)
                
                Text("Green Leaf")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Text("Gift of the moments")
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
                
                // Eingabefelder für Email und Passwort
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                
                // Login Button
                Button {
                    Task {
                        do {
                            try await viewModel.signIn(withEmail: email, password: password)
                        } catch {
                            print("Anmeldefehler: \(error)")
                        }
                    }
                } label: {
                    Text("LOG IN")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
                
                // Registrierung Link
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                .padding(.bottom, 30)
            }
            .background(Color(red: 0.9, green: 1.0, blue: 0.8)) // Hellgrüner Hintergrund für login view
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    
        LoginView()
    }


