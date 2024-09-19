//
//  SplashScreenView.swift
//  Green Leaf
//
//  Created by Maisam Ahmadi on 16.09.24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var animationEnded = false

    var body: some View {
        VStack {
            if isActive {
                WelcomeScreenView() // Wechsle zum Willkommens-Screen
            } else {
                VStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.blue)
                        .scaleEffect(animationEnded ? 1.0 : 0.6)  // Start kleiner und wächst
                        .opacity(animationEnded ? 1.0 : 0.0)  // Beginnt transparent und wird sichtbar
                        .animation(Animation.easeOut(duration: 1.0), value: animationEnded)

                    Text("Green Leaf")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                        .scaleEffect(animationEnded ? 1.0 : 0.6)  // Start kleiner und wächst
                        .opacity(animationEnded ? 1.0 : 0.0)  // Beginnt transparent und wird sichtbar
                        .animation(Animation.easeOut(duration: 1.0).delay(0.3), value: animationEnded)
                }
                .onAppear {
                    // Animation starten, sobald der Screen erscheint
                    withAnimation {
                        self.animationEnded = true
                    }
                    
                    // Warte 2 Sekunden und wechsle dann zur nächsten View
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
        .background(Color.green.edgesIgnoringSafeArea(.all))
    }
}
#Preview {
    SplashScreenView()
}
