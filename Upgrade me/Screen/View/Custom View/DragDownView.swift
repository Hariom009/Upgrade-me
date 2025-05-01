import SwiftUI

struct DragDownView<Content: View>: View {
    @Binding var isPresented: Bool
    @GestureState private var dragOffset: CGFloat = 0
    
    let contentHeightRatio: CGFloat // e.g., 0.6 for 60% of screen height
    let content: () -> Content
    
    init(isPresented: Binding<Bool>,
         contentHeightRatio: CGFloat = 0.6,
         @ViewBuilder content: @escaping () -> Content) {
        self._isPresented = isPresented
        self.contentHeightRatio = contentHeightRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                if isPresented {
                    // Dimmed background
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isPresented = false
                            }
                        }
                        .transition(.opacity)
                }

                // Pull-down panel
                VStack {
                    Capsule()
                        .frame(width: 40, height: 6)
                        .foregroundColor(.gray.opacity(0.7))
                        .padding(.top, 10)

                    content()
                        .padding(.top, 10)
                }
                .frame(width: geo.size.width,
                       height: geo.size.height * contentHeightRatio)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 10)
                .offset(y: isPresented ? dragOffset : -geo.size.height * contentHeightRatio + dragOffset)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            if value.translation.height > 0 {
                                state = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 100 {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                        }
                )
                .animation(.spring(), value: isPresented)
                .transition(.move(edge: .top))
            }
        }
    }
}

#Preview {
    DragDownView(isPresented: .constant(true)) {
        VStack(spacing: 20) {
            Text("Preview Content")
                .font(.headline)
            Text("Drag me down or tap outside to dismiss.")
        }
        .padding()
    }
}
