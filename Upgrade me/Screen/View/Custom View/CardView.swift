import SwiftUI

struct CardView: View {
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    var question: String
    var onSwipe: (Bool) -> Void  // Callback to send answer status
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: cardWidth, height: cardHeight)
                .shadow(radius: 5)
//            RadialGradient(colors: [.primaryText, .cyan
//            ], center: .leading, startRadius: 500, endRadius: 0)
            .ignoresSafeArea()
            Text(question)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(x: xOffset)
        .rotationEffect(.degrees(degrees))
        .animation(.snappy, value: xOffset)
        .gesture(
            DragGesture()
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
        )
    }
    
    private func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25)
    }
    
    private func onDragEnded(_ value: _EndedGesture<DragGesture>.Value) {
        let width = value.translation.width
        
        if abs(width) > screenCutoff {  // Check if swipe is strong enough
            let isYes = width > 0  // Right swipe = Yes, Left swipe = No
            withAnimation(.easeOut(duration: 0.3)) {
                xOffset = width > 0 ? 500 : -500  // Slide completely out
                degrees = width > 0 ? 15 : -15
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onSwipe(isYes)  // Send answer after animation completes
            }
        } else {
            // Reset position (no answer)
            withAnimation(.spring()) {
                xOffset = 0
                degrees = 0
            }
        }
    }
}

private extension CardView {
    var screenCutoff: CGFloat {
        (UIScreen.main.bounds.width / 2) * 0.4  // Adjust swipe sensitivity
    }
    var cardWidth: CGFloat {
        UIScreen.main.bounds.width - 40
    }
    var cardHeight: CGFloat {
        UIScreen.main.bounds.height / 1.6
    }
}

#Preview {
    CardView(question: "How are you?", onSwipe: { _ in })
}
