//
//  EnterNameView.swift
//  HabiT
//
//  Created by Hari's Mac on 21.03.2025.
//

import SwiftUI

struct EnterNameView: View {
    @State private var personname: String = ""
    @State private var movetoHabit: Bool = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color(red: 90/255, green: 94/255, blue: 220/255)
                .ignoresSafeArea()
                
                VStack{
                    Text("Build healthy habits with us.")
                        .foregroundStyle(.white)
                        .font(.system(size: 28, weight: .heavy))
                        .frame(width: 200,height: 200)
                        .padding()
                    Image("GuestViewImage")
                        .resizable()
                       .frame(width: 250, height: 250)
                        .scaledToFit()
                        .padding(.bottom,88)

                    FooterView
                        .padding()
                    
                }
            }
        }
    }
    private var FooterView:some View{
        VStack {
            NavigationLink("Get Started"){
               // HabitListView()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: 340,minHeight: 60)
            .background(.white)
            .foregroundStyle(.black)
            .fontWeight(.bold)
            .cornerRadius(12)
            
            VStack(spacing:1){
                Text("I have an Account")
                    .foregroundStyle(.white)
                Rectangle()
                    .fill(Color.white)
                    .frame(width:140,height: 2.5)
                
            }
            HStack(spacing: 80){
                Spacer()
                VStack{
                    Text("By starting or signing in you agree")
                        .foregroundStyle(.white)
                        .font(.caption)
                    Text("to our Terms of use")
                        .foregroundStyle(.white)
                        .font(.caption)
                }
                Spacer()
            }
            .padding(.top,12)
        }
    }
}

#Preview {
    EnterNameView()
}

