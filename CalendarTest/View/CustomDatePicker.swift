//
//  CustomDatePicker.swift
//  CalendarTest
//
//  Created by 김나연 on 2022/02/23.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0
    
    var body: some View {
        VStack(spacing: 35) {
            Text("Apus Check-In").font(.system(size: 33))
            let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraDate()[0])
                        .font(.system(size: 20))
                    Text(extraDate()[1])
                        .font(.system(size: 30))
                }
                Spacer(minLength: 0)
                Button {
                        currentMonth -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Button {
                        currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    if day == "THU" {
                        Spacer()
                        Image(systemName: "swift").foregroundColor(.blue)
                            .font(.title2)
                        Spacer()
                    } else if day == "SUN" {
                        dayText(text: day).foregroundColor(.red)
                    } else {
                        dayText(text: day)
                    }
                }
            }
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(extractDate()) { value in
                    CardView(value: value).font(.system(size: 18))
                }
            }
            .onChange(of: currentMonth) { newValue in
                currentDate = getCurrentMonth()
            }
            Spacer()
            Spacer()
        }
        .padding()
    }
    
    func dayText(text: String)->some View {
        Text(text)
            .font(.callout)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func CardView(value: DateValue)->some View {
        VStack {
            if value.day != -1 {
                Text("\(value.day)")
            }
        }
        .padding(.vertical, 8)
        .frame(height: 50, alignment: .top)
    }
    
    func extraDate()->[String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMM"
        formatter.locale = Locale(identifier:"ko_KR")
        
        let date = formatter.string(from:currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth()->Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate()->[DateValue]{
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        var days = currentMonth.getAllDates().compactMap {
            date -> DateValue in
            let day = calendar.component(.day, from: date)
//            let weekday = calendar.component(.weekday, from: date)
            return DateValue(day: day, date: date)
        }
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    
    @State static var date = Date()
    
    static var previews: some View {
        ContentView()
        CustomDatePicker(currentDate: $date)
    }
}

extension Date {
    func getAllDates()->[Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
