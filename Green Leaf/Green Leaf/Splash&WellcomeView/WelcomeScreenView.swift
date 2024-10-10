//
//  WelcomeScreenView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct WelcomeScreenView: View {
    @State private var isAnimating = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                // Logo mit Schwebebewegung
                Image(systemName: "camera.viewfinder")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.blue)
                    .scaleEffect(isAnimating ? 1.1 : 1.0) // Schwebebewegung
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                    .onAppear {
                        self.isAnimating = true
                    }

                Text("Green Leaf")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Gift of the moments")
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()

                VStack {
                    // Anmelde-Button mit Fade-in-Animation
                    NavigationLink(destination: LoginView()) {
                        Text("Anmelden")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.easeInOut(duration: 1.0).delay(0.5), value: isAnimating)
                    }

                    // Gast-Button mit Fade-in-Animation
                    NavigationLink(destination: MainTabView()) {
                        Text("Weiter als Gast")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .padding(.horizontal)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.easeInOut(duration: 1.0).delay(0.7), value: isAnimating)
                    }
                }

                Spacer()
            }
            .background(Color.green.edgesIgnoringSafeArea(.all))
        }
      
    }
}
#Preview {
    WelcomeScreenView()
}


