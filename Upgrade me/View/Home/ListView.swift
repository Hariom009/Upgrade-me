import SwiftUI
import SwiftData

struct ListView: View {
    @State private var showGraphicalCalendar = false
    @State private var dragOffset: CGFloat = 0
    @State private var currentWeekStart: Date = Calendar.current.startOfDay(for: Date()).startOfWeek()
    
    @Environment(\.dismiss) var dismiss
    @State private var showEditHabit = false
    @Environment(\.modelContext) var modelContext
    
    @State private var notificationManager = LocalNotificationManager()
    
    @Binding var selectedDate: Date
    @Binding var showBronzeStar: Bool
    @Query var activities: [Activity]
    @State private var openAddHabit = false
    @State private var selectedHabitName : String = ""
    // for animation when click the task
    @State private var pressedTaskID: UUID? = nil

    

    
    var filteredActivities: [Activity] {
        activities.filter {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }
    private var weeks: [[Date]] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .weekOfYear, value: -2, to: today.startOfWeek())!
        let endDate = calendar.date(byAdding: .weekOfYear, value: 4, to: today.startOfWeek())!

        var weekDates: [[Date]] = []
        var currentDate = startDate

        while currentDate <= endDate {
            let week = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: currentDate) }
            weekDates.append(week)
            currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate)!
        }

        return weekDates
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                if filteredActivities.isEmpty {
                    VStack(spacing: 12) {
                        Image("noHabits") // Make sure "noHabits" exists in Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .opacity(0.8)
                        
                        Text("No tasks today!")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                        
                        Text("Tap the + to add one")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .padding()
                }
                List {
                    Section{
                            ForEach(filteredActivities, id: \.id) { activity in
                                HStack {
                                    Image(activity.name.isEmpty ? "defaultImage" : activity.name)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    VStack(alignment: .leading){
                                        if activity.isRescheduled {
                                            Text("Missed from yesterday")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                                .italic()
                                        }
                                            else{
                                                  Text("\(activity.date.displayTime)")
                                                     .font(.system(size: 12))
                                                     .strikethrough(activity.isCompleted,pattern: .solid, color: .black)
                                            }
                                        
                                        if !activity.isCompleted{
                                            Text(activity.name)
                                                .fontWeight(.semibold)
                                                .font(.system(size: 15))
                                        }
                                        else{
                                                Text(activity.name)
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 15))
                                                    .strikethrough(activity.isCompleted,pattern: .solid, color: .black)
                                        }
                                    }
                                    Spacer()
                                    Button(action: {
                                        toggleCompleted(for: activity)
                                    }) {
                                        Image(systemName: activity.isCompleted ? "checkmark.seal.fill" : "circle")
                                            .foregroundColor(activity.isCompleted ? .green : .gray)
                                            .font(.title)
                                    }.buttonStyle(.borderless)
                                   
                                }
                                .padding(22)
                                .background(activity.color.opacity(0.2))
                                .foregroundColor(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                
                                // Animation after onLong Press
                                .contentShape(Rectangle())
                                .scaleEffect(pressedTaskID == activity.id ? 0.95 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: pressedTaskID == activity.id)
                                .onLongPressGesture {
                                        pressedTaskID = activity.id
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            openAddHabit = true
                                            selectedHabitName = activity.name
                                            pressedTaskID = nil
                                        }
                                }
                            }// HStack of the list instance
                        // Modifiers to perform on the overall instance at once
                        
                            .onDelete(perform: deleteActivity)
                        
                        }// Section of the lists
                    
                }// List
                
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .padding(.top, -20)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        Button {
                            showEditHabit = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 50, weight: .thin))
                                .foregroundColor(.indigo)
                        }
                    }
                }
            }
            .sheet(isPresented: $showEditHabit) {
                PreloadedTaskView()
            }
            .sheet(isPresented: $openAddHabit){
                BottomSheetEditView(activities: activities)
                    .presentationDetents([.fraction(0.3), .medium])
                    .presentationDragIndicator(.hidden)
            }
        }// NavigationStack
}

    private func toggleCompleted(for activity: Activity) {
        activity.isCompleted.toggle()
        try? modelContext.save()
        // After toggling, check if any activities are completed
        showBronzeStar = activities.contains { $0.isCompleted }
    }

    private func deleteActivity(at offsets: IndexSet) {
        for index in offsets {
            let activity = activities[index]
            notificationManager.cancelAllNotifications()
            modelContext.delete(activity)
        }
    }
}

#Preview {
    let modelContainer = try! ModelContainer(for: Activity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = modelContainer.mainContext
    context.insert(Activity(name: "Preview Task", date: .now, duration: 30, isCompleted: false))
    
    return ListView(selectedDate:.constant(Date()),showBronzeStar: .constant(true))
        .modelContainer(modelContainer)
}
