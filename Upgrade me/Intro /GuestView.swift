//
//  EnterNameView.swift
//  HabiT
//
//  Created by Hari's Mac on 21.03.2025.
//

import SwiftUI

struct GuestView: View {
    @State private var personname: String = ""
    @State private var movetoHabit: Bool = false
    @State private var isAnimating = true
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(spacing: 12){
                    
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
            //  HorizontalDatePickerView()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: 340,minHeight: 60)
            .background(.green)
            .foregroundStyle(.black)
            .fontWeight(.bold)
            .cornerRadius(12)
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
    GuestView()
}

