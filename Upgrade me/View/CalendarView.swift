//
//  CalendarView.swift
//  Upgrade me
//
//  Created by Hari's Mac on 16.04.2025.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    private var dateRange:[Date]{
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -100, to: Date())!
        let endDate = calendar.date(byAdding: .day, value: 30, to: Date())!
        
        return generateDates(from: startDate, to: endDate)
    }
    
    var body: some View {
        @State  var selectedDate: Date = Date.now
      //  let column = Array(repeating: GridItem(.flexible()), count: 7)
       // let weekdaySymbols = Calendar.current.weekdaySymbols
        
        NavigationStack{
            if selectedDate == .now {
                Text("Today")
            }
                HStack(spacing: 20){
                    
                    Text("Date : ")
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                }
                .padding(20)
        }
    }
    func generateDates(from startDate:Date, to endDate:Date) -> [Date]{
        var dates:[Date] = []
        var currentDate = startDate
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
