//
//  TaskView.swift
//  Upgrade me
//
//  Created by Hari's Mac on 17.04.2025.
//

import SwiftUI

struct TaskView: View {
    var image : String
    var text : String
    var colour : Color
    var body: some View {
        HStack{
            Image("\(image)")
                .resizable()
                .frame(width: 30, height: 30)
                .scaledToFit()
            Text("\(text)")
                .font(.headline)
                .fontWeight(.semibold)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding(20)
        .frame(width: 350, height: 90)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colour)
        )
    }
}

#Preview {
    TaskView(image: "image", text: "text", colour: .secondary)
}
