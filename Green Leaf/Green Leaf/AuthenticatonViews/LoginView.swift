//
//  LoginView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Logo
                Image(systemName: "camera.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)
                
                Text("Green Leaf")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Text("gift of the moments")
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
                
                // Username and Password TextFields
                VStack(spacing: 16) {
                    TextField("email", text: $email)
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
                
                // Log In Button
                Button {
                    Task {
                      try await viewModel.signIn(withEmail: email, password: password)
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
                
                // Forgot Password and Social Media Login
                VStack {
                    Button(action: {
                        // Handle forgot password action
                    }) {
                        Text("Forgot Password?")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 20) {
                        Image(systemName: "f.circle.fill") // Facebook Icon
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        
                        Image(systemName: "g.circle.fill") // Google Icon
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                        
                        Image(systemName: "applelogo") // Apple Icon
                            .font(.system(size: 40))
                            .foregroundColor(.black)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
                
                // Sign Up Link
                NavigationLink {
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                .padding(.bottom, 30)
                
            }
            .background(Color(red: 0.9, green: 1.0, blue: 0.8)) // Light green background
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    LoginView()
}
