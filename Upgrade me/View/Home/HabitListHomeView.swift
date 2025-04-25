import SwiftUI
import SwiftData

struct HabitListHomeView: View {
    // Streak variable
    @AppStorage("streakCount") private var streakCount = 0
    @AppStorage("lastStreakUpdated") private var lastStreakUpdated: String = ""
    // For rescheduling of task
    @Environment(\.modelContext) private var context
    @AppStorage("lastCheckedDate") var lastCheckedDate: String = ""



    @State private var showGraphicalCalendar = false
    @State private var dragOffset: CGFloat = 0
    @State private var currentWeekStart: Date = Calendar.current.startOfDay(for: Date()).startOfWeek()
    @State private var openManageTasks = false
    @State private var showEditHabit = false
    @State private var selectedDate: Date = Date()
    @State private var showBronzeStar: Bool = false
    @Query var activities :[Activity]
    
func hasCompletedActivity(on date: Date) -> Bool {
        let calendar = Calendar.current
        return activities.contains { activity in
            calendar.isDate(activity.date, inSameDayAs: date) && activity.isCompleted
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
    
    
    // Body Property
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    Color.white.opacity(0.2)
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 185)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.indigo.opacity(0.2))
                        )
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text(dateLabel(for: selectedDate))
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            // The Streak Button on Home screen
                            HStack{
                                Image(systemName: "flame.fill")
                                    .foregroundStyle(.orange)
                                    .font(.title2)
                            
                            // Here put the streak variable
                                Text("\(streakCount)")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .frame(width:60,height:30)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                            )
                            
                            Menu {
                                Button {
                                    openManageTasks = true
                                } label: {
                                    Label("Manage my tasks", systemImage: "checkmark.square")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.black)
                            }
                        }
                        .padding(.top, 55) // ensures space below notch
                        .padding(.horizontal)// ensures that buttons wont feels away from the alignment
                        
        TabView(selection: $currentWeekStart) {
                ForEach(weeks, id: \.[0]) { week in
                    HStack(spacing: 0) {
                            ForEach(week, id: \.self) { date in
                                        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                                        
                                        VStack(spacing: 4) {
                                            Text(dayOfWeek(from: date))
                                                .font(.caption)
                                                .foregroundColor(isSelected ? .black : .secondary)
                                                .fontWeight(isSelected ? .bold : .regular)
                                            
                                            let hasStreak = hasCompletedActivity(on: date)
                                            ZStack {
                                                let isToday = Calendar.current.isDateInToday(date)
                                                if hasStreak {
                                                    Image("streak")
                                                        .resizable()
                                                        .frame(width: 36, height: 36)
                                                } else {
                                                    if isToday{
                                                        Circle()
                                                            .fill(Color.white)
                                                            .frame(width: 36, height: 36)
                                                    } else {
                                                        Circle()
                                                            .fill(isSelected ? .white : Color.secondary.opacity(0.1))
                                                            .frame(width: 36, height: 36)
                                                    }
                                                    
                                                    Text(dayNumber(from: date))
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(isSelected ? .black : .gray)
                                                }
                                            }
                                            
                                        }
        
                                        .frame(width: 47, height: 71)
                                        // For that effect of light apprearance even when today is not selected
                                        .background(
                                            Group {
                                                let isToday = Calendar.current.isDateInToday(date)
                                                let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)

                                                if isSelected {
                                                    RoundedRectangle(cornerRadius: 58)
                                                        .fill(Color.purple.opacity(0.3))
                                                } else if isToday {
                                                    RoundedRectangle(cornerRadius: 58)
                                                        .fill(Color.purple.opacity(0.09)) // duller version for today
                                                } else {
                                                    Color.clear
                                                }
                                            }
                                        )                    .onTapGesture {
                                            selectedDate = date
                                        }
                                    }
                                }
                                .tag(week[0])
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 90)
                        
                        // Today Text or date text on upperright Corner of Homeview
                        HStack {
                            Spacer()
                            if !Calendar.current.isDateInToday(selectedDate) {
                                Button {
                                    let today = Calendar.current.startOfDay(for: Date())
                                    selectedDate = today
                                    currentWeekStart = today.startOfWeek()
                                } label: {
                                    Text("Today")
                                        .foregroundStyle(.black)
                                        .labelStyle(.titleAndIcon)
                                        .font(.footnote)
                                        .padding(.horizontal, 12)
                                       // .padding(.vertical, 3)
                                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.black))
                                }
                                .padding(.top, 2)
                            }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.height > 30 {
                                    withAnimation(.easeInOut) {
                                        showGraphicalCalendar = true
                                    }
                                }
                            }
                    )
                    //here i am tracking streak
                    .onChange(of: selectedDate) { _ , _ in
                        updateStreakIfNeeded()
                    }
                    .onAppear {
                        updateStreakIfNeeded()
                    }
                }
                
                // List of Habits
                
                ListView(selectedDate: $selectedDate, showBronzeStar: $showBronzeStar)
            }
            // Modifier to update the schdeduled task
            .onAppear {
                checkAndCarryOverTasksIfNeeded(context: context)
            }
            
            
            // Graphical Calendar Overlay ------------
            if showGraphicalCalendar {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showGraphicalCalendar = false
                        }
                    }
                
                VStack(spacing: 12) {
                    Capsule()
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                    
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .scaleEffect(0.9)
                        .padding()
                }
                .frame(width: 380)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                .padding(.top, 60)
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.height
                        }
                        .onEnded { value in
                            withAnimation(.easeInOut) {
                                if value.translation.height < -30 {
                                    withAnimation{
                                        showGraphicalCalendar = false
                                    }
                                }
                                dragOffset = 0
                            }
                        }
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(2)
            }// if conditon showCalendar
        }// ZStack
        .sheet(isPresented: $openManageTasks) {
            ManageTasks()
        }
    }// body
    
private func dateLabel(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
private func dayOfWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
private func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    private func updateStreakIfNeeded() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: Date()) // Use actual today's date
        let selectedDateString = formatter.string(from: selectedDate)
        
        // Check if we've already processed today
        if lastStreakUpdated == todayString {
            return
        }
        
        // Only update streak when viewing today
        if selectedDateString == todayString {
            if hasCompletedActivity(on: selectedDate) {
                streakCount += 1
                lastStreakUpdated = todayString
            } else {
                // Only reset streak at the end of the day if nothing was completed
                // You might want to use a timer or notification for this
                // For now, we'll reset when user checks today with no completions
                streakCount = 0
                lastStreakUpdated = todayString
            }
        }
    }
    // These are the functions for rescheduling
    
private func carryOverUncompletedActivities(context: ModelContext) {
        let today = Calendar.current.startOfDay(for: Date())

        let fetchDescriptor = FetchDescriptor<Activity>(
            predicate: #Predicate { activity in
                activity.isCompleted == false && activity.date < today
            }
        )

        if let oldActivities = try? context.fetch(fetchDescriptor) {
            for activity in oldActivities {
                let newActivity = Activity(
                    name : activity.name,
                    date: today,
                    duration: 0,
                    isCompleted: false,
                    isRescheduled: true
                )
                context.insert(newActivity)
            }
        }
    }

private func checkAndCarryOverTasksIfNeeded(context: ModelContext) {
        let todayString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        
        if todayString != lastCheckedDate {
            carryOverUncompletedActivities(context: context)
            lastCheckedDate = todayString
        }
    }


}

extension Date {
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
}
extension Date {
    var displayTime: String {
        self.formatted(.dateTime.hour().minute())
    }
}

#Preview {
    HabitListHomeView()
}
