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
    @State private var isAnimating = true
    var body: some View {
        NavigationStack{
            ZStack{
               // Color(red: 90/255, green: 94/255, blue: 220/255)
                //.ignoresSafeArea()
                
                VStack(spacing: 12){
                    

//                    Image("GuestViewImage")
//                        .resizable()
//                       .frame(width: 250, height: 250)
//                        .scaledToFit()
//                        .padding(.bottom,88)
                  ImageViewForIntro()
                        .padding()
                    
                    Text("Track Your Habit and Set Goals")
                        .foregroundStyle(.black)
                        .font(.system(size: 25, weight: .heavy))
                        .frame(width: 200,height: 200)
                        .padding()

                    FooterView
                        .padding()
                    
                }
                .padding(.top,20)
            }
        }
    }
    private var FooterView:some View{
        VStack {
            NavigationLink("Get Started"){
            HabitListView()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: 340,minHeight: 60)
            .background(.green)
            .foregroundStyle(.black)
            .fontWeight(.bold)
            .cornerRadius(12)
            
//            VStack(spacing:1){
//                Text("Let's Start ")
//                    .foregroundStyle(.secondary)
//                
//            }
            HStack(spacing: 80){
                Spacer()
                VStack{
                    Text("Keep Smiling and")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                    Text("Stay Consistent")
                        .foregroundStyle(.secondary)
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

