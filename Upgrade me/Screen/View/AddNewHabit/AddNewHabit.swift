import SwiftUI
import SwiftData
import UserNotifications


struct AddNewHabit: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query private var activities: [Activity]
    @EnvironmentObject var alarmManager: AlarmManager
    
    @State var habitName: String = ""
    // Time for habit to start and end in edittimeview
    @State private var time: Date = Date().addingTimeInterval(15 * 60)
    @State var endTime = Date()
    @State private var showEditTime = false
    @State private var showTimePicker = true
    @State private var periodTime = false
    
    // For alarm notification
    @State var alarmDate: Date = Date()
    // For the date task assigned
    @State var date: Date = Date()
    @State var tempduration: Int = 0
    
    @State private var selectedRepeat: RepeatOption = .None
    @State private var showRepeatPicker: Bool = false
    @State private var reminderTime: ReminderOffset = .none
    @State private var reminderType: String = "Notification"
    // For Subtask
    @State private var subtaskName: String = ""  // To capture user input for subtask
    @State private var subtasks: [Subtask] = []
    // For reminder type
    let ReminderType = ["No reminder", "Notification", "Alarm"]
    
    @State private var selectedColor: Color = Color.green.opacity(0.3)
    
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
                        if let uiImage = UIImage(named: habitName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFit()
                        } else {
                            Image("default")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .scaledToFit()
                        }
                        TextField("New Task", text: $habitName)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .textInputAutocapitalization(.none)
                    }
                    
                    ColorPaletteView(selectedColor: $selectedColor)
                    
                    Spacer()
                    // The Input View
                    
                    formInputs
                    
                        // Subtask
                    VStack(spacing: 8) {
                        // Show existing subtasks
                        ForEach(subtasks, id: \.id) { subtask in
                            HStack {
                                Text(subtask.name)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            .padding(10)
                            .frame(width: 360, height: 40)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.7)))
                            
                        }
                        
                        // TextField to add new subtasks
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                            TextField("Subtask", text: $subtaskName)
                                .onSubmit {
                                    addSubtask()
                                }
                        }
                        .padding(12)
                        .frame(width: 360, height: 50)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.7)))
                    }

                    Spacer()
                }
            }
            .onAppear {
                notificationManager.requestPermission() // Ask for permission on first open
            }
            .toolbar {
                Button {
                    let newactivity = Activity(name: habitName, date: date, duration: tempduration, isCompleted: false, subtasks: subtasks)
                    
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
           
                    if periodTime{
                        Text("\(time.formatted(date: .omitted, time: .shortened)) - \(endTime.formatted(date: .omitted, time: .shortened))")
                    }
                    else{
                        Text("\(time.formatted(date: .omitted, time: .shortened))")
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
                Text("\(selectedRepeat)")
                Button{
                    showRepeatPicker.toggle()
                }label: {
                  Image(systemName: "chevron.right")
                        .foregroundStyle(.black)
                }
            }
            .padding(15)
            
            Divider().frame(width: 300, height: 0.5).background(Color.gray.opacity(0.5))
            HStack(spacing: 12) {
                Image(systemName: "calendar.day.timeline.left").fontWeight(.bold)
                Text("Reminder")
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
                Text("Remind me @")
                Spacer()
                Picker("", selection: $reminderTime) {
                    ForEach(ReminderOffset.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            }
            .padding(15)
            
            
        }
        .frame(width: 360, height:  340)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.7)))
        .sheet(isPresented: $showEditTime){
            EditTimeView(time1: $time, time2: $endTime, showTimePicker: $showTimePicker, periodTime : $periodTime)
        }
        .sheet(isPresented: $showRepeatPicker){
            RepeatBottomSelect(selectedRepeat: $selectedRepeat, endDate: $date)
            .presentationDetents([.fraction(0.5), .medium])
            .presentationDragIndicator(.hidden)
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
        case .None:
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
        case .None:
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

    // Add Subtask
    func addSubtask() {
        guard !subtaskName.isEmpty else { return }
        let newSubtask = Subtask(name: subtaskName, isCompleted: false)
        subtasks.append(newSubtask)
        subtaskName = "" // Clear the field
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

