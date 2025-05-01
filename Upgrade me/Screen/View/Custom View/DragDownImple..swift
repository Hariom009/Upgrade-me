//
//  DragDownImple..swift
//  Upgrade me
//
//  Created by Hari's Mac on 20.04.2025.
//

import SwiftUI

struct DragDownImple_: View {
    @State private var showDragDown = false

        var body: some View {
            ZStack {
                VStack(spacing: 20) {
                    Text("Main Screen")
                        .font(.largeTitle)

                    Button("Show DragDownView") {
                        withAnimation {
                            showDragDown = true
                        }
                    }
                }

                DragDownView(isPresented: $showDragDown) {
                    VStack(spacing: 20) {
                        Text("Hello from the top 👋")
                            .font(.headline)
                        
                        Button("Dismiss") {
                            withAnimation {
                                showDragDown = false
                            }
                        }
                    }
                }
            }
        }
}

#Preview {
    DragDownImple_()
}
