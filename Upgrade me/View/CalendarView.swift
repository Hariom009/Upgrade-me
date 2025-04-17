//
//  CalendarView.swift
//  Upgrade me
//
//  Created by Hari's Mac on 16.04.2025.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = .now
    private var dateRange:[Date]{
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -100, to: Date())!
        let endDate = calendar.date(byAdding: .day, value: 30, to: Date())!
        return generateDates(from: startDate, to: endDate)
    }
    
    var body: some View {
        NavigationStack{
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.purple.opacity(0.2)) // Light violet color with 20% opacity
                        .frame(height: 200) // Adjust the height as needed
                        .ignoresSafeArea()
                    
                    HStack(spacing: 25){
                        ForEach(dateRange, id: \.self) { date in
                            VStack {
                                // Day of the week (e.g., Sun, Mon, etc.)
                                Text(dateFormatter.shortWeekdaySymbols[Calendar.current.component(.weekday, from: date) - 1])
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                // Date inside a circle
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 30, height: 30)
                                    .background(
                                        Circle()
                                            .strokeBorder(Color.secondary, lineWidth: 0.5) // secondary color border
                                            .background(Circle().fill(Color.white)) // white background
                                    )
                                    .foregroundColor(isSameDay(date: date)) // Apply the color from isSameDay function
                                    .overlay(
                                        Group {
                                            if isSameDay(date: date) == .black {
                                                Circle()
                                                    .stroke(Color.black, lineWidth: 1) // black circle border for today
                                            }
                                        }
                                    )
                                    .padding(.top, 5) // slight padding between day of the week and date
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }.scrollIndicators(.hidden)
               
        }
    }
    func generateDates(from startDate:Date, to endDate:Date) -> [Date]{
        var dates:[Date] = []
        var currentDate = startDate
        _ = Calendar.current
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day,value: 1, to: currentDate)!
        }
        return dates
    }
    
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }
    
    private func isSameDay(date: Date) -> Color {
        let tempdate = Date()
        let Formatter = DateFormatter()
        Formatter.dateFormat = "MM dd yyyy"
        let currentDateString = Formatter.string(from: tempdate)
        let dateString = Formatter.string(from: date)
        
        if currentDateString == dateString {
            return .black
        }
        else {
            return .gray
        }
    }
}

#Preview {
    CalendarView()
}
