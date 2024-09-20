//
//  SignUpView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct SignUpView: View {
    
    
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Let's Get Started!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.bottom, 40)
                
                // Full Name, Email, Password, and Confirm Password TextFields
                VStack(spacing: 16) {
                    TextField("Full Name", text: $viewModel.fullName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                
                // Sign Up Button
                Button(action: viewModel.register) {
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
                
                // Already have an account Link
                NavigationLink {
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(){
                        Text("Already have an account?")
                        Text("Login here")
                            .fontWeight(.bold)
                    }
                }
                .font(.footnote)
                .padding(.bottom, 30)
            }
            .background(Color(red: 0.9, green: 1.0, blue: 0.8)) // Light green background
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    SignUpView().environmentObject(AuthViewModel())
}
