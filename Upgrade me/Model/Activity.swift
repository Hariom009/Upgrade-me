import SwiftUI
import SwiftData

@Model
class Activity {
    var id: UUID
    var name: String
    var date: Date
    var duration: Int
    var colorName: String
    var isCompleted: Bool

    init(id: UUID = UUID(), name: String, date: Date, duration: Int, colorName: String = Activity.randomColorName(), isCompleted: Bool = false){
        self.id = id
        self.name = name
        self.date = date
        self.duration = duration
        self.colorName = colorName // The color is set once when the activity is created
        self.isCompleted = isCompleted
    }

    static func randomColorName() -> String {
        let colorOptions = ["red", "blue", "green", "purple", "orange", "pink", "indigo", "teal"]
        return colorOptions.randomElement() ?? "blue"
    }
    
    var color: Color {
        switch colorName {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "pink": return .pink
        case "indigo": return .indigo
        case "teal": return .teal
        default: return .blue
        }
    }
}
