//
//  SignUpView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @EnvironmentObject private var viewModel: FirebaseViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Let's Get Started!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .padding(.bottom, 40)
            
            VStack(spacing: 16) {
                TextField("Full Name", text: $fullName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
                
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
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal)
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.createUser(withEmail: email, password: password, fullName: fullName)
                    } catch {
                        print("Registrierungsfehler: \(error)")
                    }
                }
            }) {
                Text("Sign up")
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
            
            NavigationLink("Already have an account? Login", destination: LoginView())
                .font(.footnote)
                .padding(.bottom, 30)
        }
        .background(Color(red: 0.9, green: 1.0, blue: 0.8).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    SignUpView()
        .environmentObject(FirebaseViewModel())
}

