//
//  ContentView.swift
//  Upgrade me
//
//  Created by Hari's Mac on 16.04.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            HorizontalDatePickerView()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
