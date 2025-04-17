
import SwiftUI
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

struct EditNewHabit: View {
    @Environment(\.dismiss) var dismiss
    @State var habitName: String = ""
    @State var time  = Date()
    @State var date: Date = Date()
    @State var tempduration : Int = 0
    
    @State private var selectedRepeat: RepeatOption = .daily
    
    var activitymanager: ActivityManager
    
    @State private var isReminderOn = false
    @State private var reminderTime: ReminderOffset = .none
    
    @State private var tag: String = ""
    @State private var subtasks = ""
    let tags = ["Workout", "Study", "Personal", "Health", "Travel", "Shopping"]
    @State private var selectedColor: Color = Color.green.opacity(0.3)
    var isValid: Bool{
        !habitName.isEmpty
    }
    
    // BODY Property ------- HERE----------
    
    var body: some View {
        NavigationStack{
            ZStack{
                selectedColor
                    .ignoresSafeArea()
                VStack(spacing: 8){
                    VStack{
                    Text(emojiForHabit(habitName))
                           .font(.largeTitle)
                           .frame(maxWidth: .infinity, alignment: .center)
                           .listRowBackground(Color.clear)

                       TextField("New Task", text: $habitName)
                           .font(.title)
                           .fontWeight(.bold)
                           .multilineTextAlignment(.center)
                           .listRowBackground(Color.clear)

                       if !habitName.isEmpty {
                           Text("Tap to rename")
                               .padding(3)
                               .foregroundStyle(.secondary)
                               .frame(maxWidth: .infinity, alignment: .center)
                               .listRowBackground(Color.clear)
                    }
                }
                    
                    ScrollView(.horizontal){
                        HStack(spacing: 20) {
                            // Light Peach
                             Color(red: 1.0, green: 0.8, blue: 0.7) // Light peach
                                 .frame(width: 40, height: 40)
                                 .clipShape(Circle())
                                 .overlay(
                                     Circle() // White border circle
                                         .stroke(Color.white, lineWidth: 2) // White border with thickness
                                 )
                                 .overlay(
                                     Group {
                                         if selectedColor == Color(red: 1.0, green: 0.8, blue: 0.7) {
                                             Image(systemName: "checkmark")
                                                 .foregroundColor(.black) // Tick color
                                                 .font(.title2) // Tick font size
                                         }
                                     }
                                 )
                                 .onTapGesture {
                                     selectedColor = Color(red: 1.0, green: 0.8, blue: 0.7)
                                 }
                             
                             // Light Pink
                             Color(red: 1.0, green: 0.8, blue: 0.9) // Light pink
                                 .frame(width: 40, height: 40)
                                 .clipShape(Circle())
                                 .overlay(
                                     Circle() // White border circle
                                         .stroke(Color.white, lineWidth: 2) // White border with thickness
                                 )
                                 .overlay(
                                     Group {
                                         if selectedColor == Color(red: 1.0, green: 0.8, blue: 0.9) {
                                             Image(systemName: "checkmark")
                                                 .foregroundColor(.black) // Tick color
                                                 .font(.title2) // Tick font size
                                         }
                                     }
                                 )
                                 .onTapGesture {
                                     selectedColor = Color(red: 1.0, green: 0.8, blue: 0.9)
                                 }
                             
                             // Soft Lavender
                             Color(red: 0.8, green: 0.7, blue: 1.0) // Soft lavender
                                 .frame(width: 40, height: 40)
                                 .clipShape(Circle())
                                 .overlay(
                                     Circle() // White border circle
                                         .stroke(Color.white, lineWidth: 2) // White border with thickness
                                 )
                                 .overlay(
                                     Group {
                                         if selectedColor == Color(red: 0.8, green: 0.7, blue: 1.0) {
                                             Image(systemName: "checkmark")
                                                 .foregroundColor(.black) // Tick color
                                                 .font(.title2) // Tick font size
                                         }
                                     }
                                 )
                                 .onTapGesture {
                                     selectedColor = Color(red: 0.8, green: 0.7, blue: 1.0)
                                 }
                             
                             // Mint Green
                             Color(red: 0.6, green: 1.0, blue: 0.6) // Mint green
                                 .frame(width: 40, height: 40)
                                 .clipShape(Circle())
                                 .overlay(
                                     Circle() // White border circle
                                         .stroke(Color.white, lineWidth: 2) // White border with thickness
                                 )
                                 .overlay(
                                     Group {
                                         if selectedColor == Color(red: 0.6, green: 1.0, blue: 0.6) {
                                             Image(systemName: "checkmark")
                                                 .foregroundColor(.black) // Tick color
                                                 .font(.title2) // Tick font size
                                         }
                                     }
                                 )
                                 .onTapGesture {
                                     selectedColor = Color(red: 0.6, green: 1.0, blue: 0.6)
                                 }
                             
                             // Pale Yellow
                             Color(red: 1.0, green: 1.0, blue: 0.8) // Pale yellow
                                 .frame(width: 40, height: 40)
                                 .clipShape(Circle())
                                 .overlay(
                                     Circle() // White border circle
                                         .stroke(Color.white, lineWidth: 2) // White border with thickness
                                 )
                                 .overlay(
                                     Group {
                                         if selectedColor == Color(red: 1.0, green: 1.0, blue: 0.8) {
                                             Image(systemName: "checkmark")
                                                 .foregroundColor(.black) // Tick color
                                                 .font(.title2) // Tick font size
                                         }
                                     }
                                 )
                                 .onTapGesture {
                                     selectedColor = Color(red: 1.0, green: 1.0, blue: 0.8)
                                 }
                             
                             // Soft Coral
                             Color(red: 1.0, green: 0.6, blue: 0.6) // Soft coral
                                 .frame(width: 40, height: 40)
                                 .clipShape(Circle())
                                 .overlay(
                                     Circle() // White border circle
                                         .stroke(Color.white, lineWidth: 2) // White border with thickness
                                 )
                                 .overlay(
                                     Group {
                                         if selectedColor == Color(red: 1.0, green: 0.6, blue: 0.6) {
                                             Image(systemName: "checkmark")
                                                 .foregroundColor(.black) // Tick color
                                                 .font(.title2) // Tick font size
                                         }
                                     }
                                 )
                                 .onTapGesture {
                                     selectedColor = Color(red: 1.0, green: 0.6, blue: 0.6)
                                 }
                            // Separate one
                            Color(red: 1.1, green: 0.5, blue: 0.3) // Soft coral
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(
                                    Circle() // White border circle
                                        .stroke(Color.white, lineWidth: 2) // White border with thickness
                                )
                                .overlay(
                                    Group {
                                        if selectedColor == Color(red: 1.1, green: 0.5, blue: 0.3) {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.black) // Tick color
                                                .font(.title2) // Tick font size
                                        }
                                    }
                                )
                                .onTapGesture {
                                    selectedColor = Color(red: 1.1, green: 0.5, blue: 0.3)
                                }
                        }
                    }
            
                Spacer()
                VStack(spacing: 8){
                    HStack(spacing: 12){
                        Image(systemName: "calendar")
                        DatePicker("Date",selection: $date,displayedComponents: [.date])
                            .listRowBackground(Color.white.opacity(0.5))
                    }
                    .padding(15)
                    Divider()
                        .frame(width: 300,height: 0.5)
                        .background(Color.gray.opacity(0.5))
                    
                    HStack(spacing: 12){
                        Image(systemName: "clock")
                        DatePicker("Time", selection: $time, displayedComponents:.hourAndMinute)
                    }
                    .padding(15)
                    Divider()
                        .frame(width: 300,height: 0.5)
                        .background(Color.gray.opacity(0.5))
                    
                    HStack(spacing: 12){
                        Image(systemName: "repeat.circle")
                        Text("Repeat")
                        Spacer()
                        Picker("", selection: $selectedRepeat) {
                            ForEach(RepeatOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    }
                    .padding(15)
                    Divider()
                        .frame(width: 300,height: 0.5)
                        .background(Color.gray.opacity(0.5))
                    
                    HStack(spacing: 12){
                        Image(systemName: "clock.fill")
                        Text("Reminder")
                        Spacer()
                        Picker("", selection: $reminderTime){
                            ForEach(ReminderOffset.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    }
                    .padding(15)
                    Divider()
                        .frame(width: 300,height: 0.5)
                        .background(Color.gray.opacity(0.5))
                    
                    HStack(spacing: 12){
                        Image(systemName: "tag.fill")
                        Text("Tag")
                        Spacer()
                        Picker("", selection: $tag){
                            ForEach(tags, id:\.self){
                                Text($0).tag($0)
                            }
                        }
                    }
                    .padding(15)
                }
                
                .frame(width: 350, height:  400)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.7)) // or any custom color
                )
                VStack{
                    HStack(spacing: 30){
                            Image(systemName: "plus")
                                .offset(x:25)
                            TextField("Subtasks", text:$subtasks)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.7))
                            .frame(width: 340)
                          // or any custom color
                    )
                }
              Spacer()
            }
                
                VStack(spacing: 12){
                    Spacer()
                    
                    Button("Finish"){
                        let newactivity = Activity(name: habitName, date: date, duration:tempduration)
                        activitymanager.addActivity(newactivity)
                        dismiss()
                    }
                    .frame(maxWidth: 320,minHeight: 55)
                    .background(.white)
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                    .cornerRadius(20)
                    .padding(.top,20)
                }
                
                
            }
          //  .navigationTitle("Add new Habit")
          //  .navigationBarTitleDisplayMode(.inline)
//            .toolbar{
//                Button{
//                    let newactivity = Activity(name: habitName, date: date, duration: tempduration)
//                    activitymanager.addActivity(newactivity)
//                    dismiss()
//                }label: {
//                    Image(systemName: "xmark")
//                }
//                .disabled(!isValid)
//            }
        }
    }
    func emojiForHabit(_ name: String) -> String {
        let lowercased = name.lowercased()
        
        if lowercased.contains("run") || lowercased.contains("jog") {
            return "🏃‍♂️"
        } else if lowercased.contains("drink") {
            return "🥤"
        } else if lowercased.contains("read") {
            return "📚"
        } else if lowercased.contains("code") {
            return "💻"
        } else if lowercased.contains("sleep") {
            return "😴"
        } else if lowercased.contains("meditate") {
            return "🧘‍♂️"
        } else if lowercased.contains("workout") || lowercased.contains("gym") {
            return "🏋️"
        } else if lowercased.contains("eat") || lowercased.contains("food") {
            return "🍽️"
        } else {
            return "🌻" // default fallback emoji
        }
    }
}

#Preview {
    EditNewHabit(activitymanager: ActivityManager())
}

