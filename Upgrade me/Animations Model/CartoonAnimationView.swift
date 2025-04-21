//
//  CartoonAnimationView.swift
//  Upgrade me
//
//  Created by Hari's Mac on 19.04.2025.
//


import SwiftUI

struct CartoonAnimationView: View {
    @State private var rotate = true // State variable to trigger animation
    
    var body: some View{
        VStack{
            Text("You're doing great! Keep going!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .transition(.opacity)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: rotate)
        }
    }
}

#Preview {
    CartoonAnimationView()
}
