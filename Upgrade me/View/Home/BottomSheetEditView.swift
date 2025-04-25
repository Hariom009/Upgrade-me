//
//  BottomSheetEditView.swift
//  Upgrade me
//
//  Created by Hari's Mac on 22.04.2025.
//

import SwiftUI

struct BottomSheetEditView: View {
    @State private var showEditHabit : Bool = false
      var activities : [Activity]
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.cyan.opacity(0.2))
                .ignoresSafeArea()
            VStack{
                HStack{
                    Image("\(activities[0].name)")
                        .resizable()
                        .frame(width: 60,height: 60)
                    
                    VStack(alignment: .leading){
                        Text("\(activities[0].isCompleted ? "Completed" : "Not Completed")")
                        Text("\(activities[0].name)")
                    }
                    
                    Spacer()
                    Button{
                        activities[0].isCompleted.toggle()
                    }label:{
                        Image(systemName:activities[0].isCompleted ? "checkmark.seal.fill" : "circle")
                            .font(.title2)
                            .foregroundStyle(activities[0].isCompleted ? .green : .black)
                        }
                    }
                Spacer()
                Button("EditTask"){
                   showEditHabit = true
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.6))
                )
                .foregroundStyle(.black)
                
            }
                .padding()
            }
          .sheet(isPresented: $showEditHabit){
              AddNewHabit(habitName: activities[0].name)
          }
        }
    }

#Preview {
    BottomSheetEditView(activities: [Activity(name: "Preview", date: Date.now, duration: 0, isCompleted: false)])
}
