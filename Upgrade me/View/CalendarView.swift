import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @State private var todaysDate: Date = Date.now
    @State private var showCalendar: Bool = false
    @State private var dragOffset: CGFloat = 0

    private var dateRange: [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -2, to: Date())!
        let endDate = calendar.date(byAdding: .day, value: 30, to: Date())!
        return generateDates(from: startDate, to: endDate)
    }

    var body: some View {
        
        VStack(spacing: 0){
            ZStack {
                if showCalendar {
                    // Show graphical calendar when toggled
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .scaleEffect(0.7)
                        .frame(width: 380, height: 240)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(radius: 20)
                        )
                        .offset(y: dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation.height
                                }
                                .onEnded { value in
                                    withAnimation(.easeInOut) {
                                        if value.translation.height < -30 {
                                            showCalendar = false
                                        }
                                        dragOffset = 0
                                    }
                                }
                        )
                        .opacity(showCalendar ? 1 : 0)
                        .offset(y: showCalendar ? 0 : -50)
                        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: showCalendar)
                }
            }
        }
        .padding(2)
    }

    func generateDates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }

    private func isSameDay(date: Date) -> Color {
        let tempDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM dd yyyy"
        let currentDateString = formatter.string(from: tempDate)
        let dateString = formatter.string(from: date)
        return currentDateString == dateString ? .black : .gray
    }
}

#Preview {
    CalendarView(selectedDate: .constant(Date()))
}
