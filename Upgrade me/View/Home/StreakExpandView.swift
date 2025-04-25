import SwiftUI

struct StreakExpandView: View {
    @Binding var streakCount : Int
    @State private var streakIsZero : Bool = true
    var body: some View {
        NavigationStack{
            VStack{
                Image("flame")
                    .resizable()
                    .frame(width: 200,height: 200)
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    StreakExpandView(streakCount: .constant(0))
}
