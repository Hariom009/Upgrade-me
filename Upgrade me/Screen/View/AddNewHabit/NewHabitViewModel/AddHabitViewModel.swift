import Foundation
import SwiftUI

class AddHabitViewModel: ObservableObject {
       @Published var habitName: String = ""
       @Published var time: Date = Date()
       @Published var endTime: Date = Date()
       @Published var showEditTime = false
       @Published var showTimePicker = false
       @Published var periodTime = false
       @Published var alarmDate: Date = Date()
       @Published var date: Date = Date()
       @Published var tempduration: Int = 0
       @Published var selectedRepeat: RepeatOption = .None
       @Published var showRepeatPicker: Bool = false
       @Published var reminderTime: ReminderOffset = .none
       @Published var reminderType: String = "Notification"
       @Published var selectedColor: Color = Color.green.opacity(0.3)
       @Published var subtaskName: String = ""
    
    var notificationManager = LocalNotificationManager()

     var isValid: Bool {
         !habitName.isEmpty
     }
    func combineDateAndTime() -> Date? {
          let calendar = Calendar.current
          var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
          let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
          
          dateComponents.hour = timeComponents.hour
          dateComponents.minute = timeComponents.minute
          
          return calendar.date(from: dateComponents)
      }
}
