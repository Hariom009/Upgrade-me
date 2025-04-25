import SwiftUI
import SwiftData
import MCEmojiPicker
import UserNotifications

enum RepeatOption: String, CaseIterable, Identifiable {
    case noRepeat = "No Repeat"
    case daily = "Daily"
    case weekends = "Weekends"
    case monthly = "Monthly"
    
    var id: String { self.rawValue }
}

enum ReminderOffset: String, CaseIterable, Identifiable {
    case none = "On time"
    case tenMinutes = "10 minutes early"
    case thirtyMinutes = "30 minutes early"
    case oneHour = "1 hour early"
    
    var id: String { self.rawValue }
    
    var offsetInMinutes: Int? {
        switch self {
        case .none: return 0
        case .tenMinutes: return 10
        case .thirtyMinutes: return 30
        case .oneHour: return 60
        }
    }
}

struct AddNewHabit: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query private var activities: [Activity]
    @EnvironmentObject var alarmManager: AlarmManager
    
    @State var habitName: String = ""
    
    // Time for habit to start and end in edittimeview
    @State var time = Date()
    @State var endTime = Date()
    @State private var showEditTime = false
    @State private var showTimePicker = false
    @State private var periodTime = false
    
    // For alarm notification
    @State var alarmDate: Date = Date()
    // For the date task assigned
    @State var date: Date = Date()
    @State var tempduration: Int = 0
    
    @State private var selectedRepeat: RepeatOption = .noRepeat
    @State private var reminderTime: ReminderOffset = .none
    @State private var reminderType: String = "Notification"
    // For Subtask
    @State private var subtasks = ""
    // For reminder type
    let ReminderType = ["No reminder", "Notification", "Alarm"]
    
    @State private var selectedColor: Color = Color.green.opacity(0.3)
    @State private var openEmojiPicker: Bool = false
    @State private var emoji = ""
    
    @State private var notificationManager = LocalNotificationManager()
    
    var isValid: Bool {
        !habitName.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                selectedColor
                    .ignoresSafeArea()
                
                VStack(spacing: 8) {
                    VStack {
                        if habitName.isEmpty {
                            Image("default")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFit()
                        }else{
                            Image("\(habitName)")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFit()
                        }
                        TextField("New Task", text: $habitName)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .textInputAutocapitalization(.none)
                        
                        if !habitName.isEmpty {
                            Button {
                                openEmojiPicker.toggle()
                            } label: {
                                Text("Tap to Edit")
                                    .padding(3)
                                    .font(.caption)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    
                    ColorPaletteView(selectedColor: $selectedColor)
                    Spacer()
                    // The Input View
                    
                    formInputs
                    Spacer()
                }
            }
            .onAppear {
                notificationManager.requestPermission() // Ask for permission on first open
            }
            .toolbar {
                Button {
                    let newactivity = Activity(name: habitName, date: date, duration: tempduration, isCompleted: false)
                       modelContext.insert(newactivity)
                    if let combinedDate = combineDateAndTime(date: date, time: time) {
                        if reminderType == "Alarm"{
                            scheduleAlarm(for: combinedDate)
                        }
                        else if reminderType == "Notification"{
                            scheduleNotification(for: combinedDate)
                        }
                    }
                    
                    dismiss()
                    dismiss()
                } label: {
                    Text("Create")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
    // MARK: - Form Inputs
    var formInputs: some View {
        VStack(spacing: 3) {
            NavigationLink(destination: EditDateAddedView(date: $date)) {
                HStack(spacing: 12) {
                    Image(systemName: "calendar").fontWeight(.bold)
                    Text("Date")
                    Spacer()
                    Text("\(date.displayDate)")
                    Image(systemName:"chevron.right")
                }
                .foregroundStyle(Color.black)
                .padding(15)
            }
            
            Divider().frame(width: 300, height: 0.5).background(Color.gray.opacity(0.5))
            
            HStack(spacing: 12) {
                Image(systemName: "clock")
                Text("Time")
                Spacer()
                if !showTimePicker{
                    Text("Anytime")
                }else{
                    if periodTime{
                        Text("\(time.formatted(date: .omitted, time: .shortened)) - \(endTime.formatted(date: .omitted, time: .shortened))")
                    }
                    else{
                        Text("\(time.formatted(date: .omitted, time: .shortened))")
                    }
                }
                Button{
                    withAnimation{
                        showEditTime.toggle()
                    }
                }label: {
                    Image(systemName:"chevron.right")
                        .foregroundStyle(Color.black)
                }
            }
            .padding(15)
            
            Divider().frame(width: 300, height: 0.5).background(Color.gray.opacity(0.5))
            
            HStack(spacing: 12) {
                Image(systemName: "repeat.circle").fontWeight(.bold)
                Text("Repeat")
                Spacer()
                Picker("", selection: $selectedRepeat) {
                    ForEach(RepeatOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            }
            .padding(15)
            
            Divider().frame(width: 300, height: 0.5).background(Color.gray.opacity(0.5))
            HStack(spacing: 12) {
                Image(systemName: "calendar.day.timeline.left").fontWeight(.bold)
                Text("Reminder type ")
                Spacer()
                Picker("", selection: $reminderType) {
                    ForEach(ReminderType, id: \.self) {
                        Text($0).tag($0)
                    }
                }
            }
            .padding(15)
            Divider().frame(width: 300, height: 0.5).background(Color.gray.opacity(0.5))
            
            HStack(spacing: 12) {
                Image(systemName: "clock.fill")
                Text("Remind me at")
                Spacer()
                Picker("", selection: $reminderTime) {
                    ForEach(ReminderOffset.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            }
            .padding(15)
            Divider().frame(width: 300, height: 0.5).background(Color.gray.opacity(0.5))
        
            // Subtask
            HStack(spacing: 2) {
                Image(systemName: "plus")
                Spacer()
                TextField("Subtask", text: $subtasks)
            }
            .padding(15)
           
        }
        .frame(width: 350, height:  390)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.7)))
        .sheet(isPresented: $showEditTime){
            EditTimeView(time1: $time, time2: $endTime, showTimePicker: $showTimePicker, periodTime : $periodTime)
        }
    }
    
    // MARK: - Combine Date and Time
    func combineDateAndTime(date: Date, time: Date) -> Date? {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        return calendar.date(from: dateComponents)
    }
    
    // MARK: - Schedule Notification
    func scheduleNotification(for baseDate: Date) {
        var finalDate = baseDate
        
        if let offset = reminderTime.offsetInMinutes {
            finalDate = Calendar.current.date(byAdding: .minute, value: -offset, to: baseDate) ?? baseDate
        }
        
        let calendar = Calendar.current
        
        switch selectedRepeat {
        case .noRepeat:
            let components = calendar.dateComponents([.hour, .minute], from: finalDate)
            notificationManager.scheduleNotification(title: "Habit Reminder", body: habitName, dateComponents: components, repeats: false)
            
        case .daily:
            let components = calendar.dateComponents([.hour, .minute], from: finalDate)
            notificationManager.scheduleNotification(title: "Habit Reminder", body: habitName, dateComponents: components, repeats: true)
            
        case .weekends:
            for weekday in [7, 1] { // Sunday (1), Saturday (7)
                var components = calendar.dateComponents([.hour, .minute], from: finalDate)
                components.weekday = weekday
                notificationManager.scheduleNotification(title: "Weekend Habit Reminder", body: habitName, dateComponents: components, repeats: true)
            }
            
        case .monthly:
            let components = calendar.dateComponents([.day, .hour, .minute], from: finalDate)
            notificationManager.scheduleNotification(title: "Monthly Habit Reminder", body: habitName, dateComponents: components, repeats: true)
        }
    }
    
    
    // SCHEDULE ALARM -----
    
    func scheduleAlarm(for baseDate: Date) {
        var finalDate = baseDate
        
        if let offset = reminderTime.offsetInMinutes {
            finalDate = Calendar.current.date(byAdding: .minute, value: -offset, to: baseDate) ?? baseDate
        }
        
        let calendar = Calendar.current
        let title = "Habit Alarm"
        let message = habitName

        switch selectedRepeat {
        case .noRepeat:
            AlarmManager.shared.scheduleAlarm(at: finalDate, title: title, message: message)
            
        case .daily:
            let components = calendar.dateComponents([.hour, .minute], from: finalDate)
            for _ in 0..<7 {
                if let nextDate = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .forward) {
                    AlarmManager.shared.scheduleAlarm(at: nextDate, title: title, message: message)
                }
            }
            
        case .weekends:
            for weekday in [1, 7] { // Sunday and Saturday
                var components = calendar.dateComponents([.hour, .minute], from: finalDate)
                components.weekday = weekday
                if let nextWeekend = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTimePreservingSmallerComponents) {
                    AlarmManager.shared.scheduleAlarm(at: nextWeekend, title: "Weekend Habit Alarm", message: message)
                }
            }
            
        case .monthly:
            let components = calendar.dateComponents([.day, .hour, .minute], from: finalDate)
            if let nextMonthDate = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTimePreservingSmallerComponents) {
                AlarmManager.shared.scheduleAlarm(at: nextMonthDate, title: "Monthly Habit Alarm", message: message)
            }
        }
    }

}

extension Date {
    var displayDate: String {
        self.formatted(.dateTime.day().month(.wide).year())
    }
}


#Preview {
    AddNewHabit()
        .environmentObject(AlarmManager.shared)
}

