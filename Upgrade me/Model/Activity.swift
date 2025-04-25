import SwiftUI
import SwiftData

@Model
class Activity {
    var id: UUID
    var name: String
    var date: Date
    var duration: Int // this is the streak which we are maintaining 
    var colorName: String
    var isCompleted: Bool
    var isRescheduled: Bool = false
    var subtask : String = ""

    init(id: UUID = UUID(), name: String, date: Date, duration: Int, colorName: String = Activity.randomColorName(), isCompleted: Bool = false, isRescheduled: Bool = false, subtask : String = ""){
        self.id = id
        self.name = name
        self.date = date
        self.duration = duration
        self.colorName = colorName // The color is set once when the activity is created
        self.isCompleted = isCompleted
        self.isRescheduled = isRescheduled // The activity which are not completed previous day
        self.subtask = subtask // for the subtask below the task 
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
