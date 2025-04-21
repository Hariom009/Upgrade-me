import SwiftUI
import SwiftData
import MCEmojiPicker
import UserNotifications

enum RepeatOption: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekends = "Weekends"
    case monthly = "Monthly"
    
    var id: String { self.rawValue }
}

enum ReminderOffset: String, CaseIterable, Identifiable {
    case none = "No Reminder"
    case tenMinutes = "10 minutes early"
    case thirtyMinutes = "30 minutes early"
    case oneHour = "1 hour early"
    
    var id: String { self.rawValue }
    
    var offsetInMinutes: Int? {
        switch self {
        case .none: return nil
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
    @State var habitName: String = ""
    @State var time = Date()
    @State var date: Date = Date()
    @State var tempduration: Int = 0
    
    @State private var selectedRepeat: RepeatOption = .daily
    @State private var reminderTime: ReminderOffset = .none
    @State private var tag: String = "No Tag"
    @State private var subtasks = ""
    let tags = ["No Tag","Workout", "Study", "Personal", "Health", "Travel", "Shopping"]
    
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
                        
                        // Here is the Emoji picker to pick any emoji you want to
//                        Button(emoji.isEmpty ? "🔆" : "") {
//                            openEmojiPicker.toggle()
//                        }
//                        .emojiPicker(isPresented: $openEmojiPicker, selectedEmoji: $emoji)
                        
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
                        scheduleNotification(for: combinedDate)
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
            
            Divider().frame(width: 300, height: 0.5)
            
            HStack(spacing: 12) {
                Image(systemName: "clock")
                Text("Time")
                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
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
                Image(systemName: "clock.fill")
                Text("Reminder")
                Spacer()
                Picker("", selection: $reminderTime) {
                    ForEach(ReminderOffset.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            }
            .padding(15)
            
            Divider().frame(width: 300, height: 0.5).background(Color.gray.opacity(0.5))
            
            HStack(spacing: 12) {
                Image(systemName: "tag.fill").fontWeight(.bold)
                Text("Tag")
                Spacer()
                Picker("", selection: $tag) {
                    ForEach(tags, id: \.self) {
                        Text($0).tag($0)
                    }
                }
            }
            .padding(15)
        }
        .frame(width: 350, height:  360)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.7)))
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
            var components = calendar.dateComponents([.day, .hour, .minute], from: finalDate)
            notificationManager.scheduleNotification(title: "Monthly Habit Reminder", body: habitName, dateComponents: components, repeats: true)
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
}

