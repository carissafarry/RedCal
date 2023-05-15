//
//  AddPeriod.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 12/05/23.
//

import SwiftUI

struct AddPeriod: View {
    @Environment(\.calendar) var calendar
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var periodManager: PeriodManager
    
    @State private var selectedDates: Set<DateComponents> = []
    @State private var startDate: DateComponents?
    @State private var endDate: DateComponents?
    @State private var period: Period?
    
    
    var bounds: Range<Date> {
        let start = calendar.date(from: startDate!)!
        let end = calendar.date(from: endDate!)!
        
        return start ..< end
    }
    
    func getFirstAndLastDate(from dates: Set<DateComponents>) -> (DateComponents?, DateComponents?) {
        let sortedDates = dates.sorted(by: { date1, date2 in
            guard let date1Date = calendar.date(from: date1),
                  let date2Date = calendar.date(from: date2) else {
                return false
            }
            return date1Date < date2Date
        })
        
        let firstDate = sortedDates.first
        let lastDate = sortedDates.last
        
        return (firstDate, lastDate)
    }
    
    func insertDatesBetweenFirstAndLast(from firstDate: Date, to lastDate: Date) {
        var startDate = calendar.startOfDay(for: firstDate)
        let endDate = calendar.startOfDay(for: lastDate)
        
        print(startDate)
        print(endDate)
        print("\n")
        
        period = Period(startDate: startDate, endDate: endDate, duration: 0, cycleLength: 0)
        // TODO: Count duration + cycle length
        
        while startDate <= endDate {
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
            selectedDates.insert(dateComponents)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
    }
    
    
    var body: some View {
        NavigationView {
          List {
              MultiDatePicker("Select Date", selection: $selectedDates)
                  .datePickerStyle(GraphicalDatePickerStyle())
                  .onChange(of: selectedDates) { dates in
                      (startDate, endDate) = getFirstAndLastDate(from: selectedDates)
                      
                      insertDatesBetweenFirstAndLast(
                        from: (calendar.date(from: startDate!)!),
                        to: (calendar.date(from: endDate!)!)
                      )
                  }
          }
          .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    if let period = period {
                        periodManager.addPeriod(period)
                    }
                    print(periodManager.periods)
                    dismiss()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
          }
          .navigationTitle("Add Period")
          .navigationBarTitleDisplayMode(.inline)
        }
    }
        
}

struct AddPeriod_Previews: PreviewProvider {
    static var previews: some View {
        AddPeriod()
    }
}
