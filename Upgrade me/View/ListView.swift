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
    
    @Binding  var selectedDate: Date
    @Query var activities: [Activity]
    
    @State private var openAddHabit = false
    @State private var selectedHabitName : String = ""

    
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
            List {
             Section(header: Text("My Task")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .textCase(nil)) {
                    ForEach(filteredActivities, id: \.id) { activity in
                        HStack {
                            Image(activity.name.isEmpty ? "defaultImage" : activity.name)
                                .resizable()
                                .frame(width: 30, height: 30)
                            VStack(alignment: .leading){
                                
                                Text("\(activity.date.displayTime)")
                                    .font(.system(size: 12))
                                if !activity.isCompleted{
                                    Text(activity.name)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))
                                }else{
                                    ZStack{
                                        Rectangle()
                                            .fill(Color.black.opacity(0.8))
                                            .frame(width: 100,height: 2)
                                        Text(activity.name)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 15))
                                        
                                    }
                                }
                            }
                            Spacer()
                            Button(action: {
                                toggleCompleted(for: activity)
                            }) {
                                Image(systemName: activity.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(activity.isCompleted ? .green : .gray)
                                    .font(.title)
                            }.buttonStyle(.borderless)
                            Button{
                                openAddHabit = true
                                selectedHabitName = activity.name
                            }label:{
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }.buttonStyle(.borderless)
                        }
                        .padding(22)
                        .background(activity.color.opacity(0.2))
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .onDelete(perform: deleteActivity)
                }
        }// List
        
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .padding(.top, -20)
    }// NavigationStack
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
        AddNewHabit(habitName: selectedHabitName)
    }
}

    private func toggleCompleted(for activity: Activity) {
        activity.isCompleted.toggle()
        try? modelContext.save()
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
    
   return ListView(selectedDate:.constant(Date()))
        .modelContainer(modelContainer)
}
