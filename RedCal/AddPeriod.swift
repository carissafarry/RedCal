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
    
    @EnvironmentObject var answerManager: AnswerManager
    @EnvironmentObject var periodManager: PeriodManager
    
    @Binding var periods: [Period]
    
    @State private var selectedDates: Set<DateComponents> = []
    @State private var startDate: DateComponents?
    @State private var endDate: DateComponents?
    @State private var period: Period?
    @State private var duration: Int?
    @State private var cycleLength: Int?
    
    
    var body: some View {
        NavigationView {
          List {
              MultiDatePicker("Select Date", selection: $selectedDates, in: bounds!)
                  .datePickerStyle(GraphicalDatePickerStyle())
                  .onChange(of: selectedDates) { dates in
                      (startDate, endDate) = getFirstAndLastDate(from: selectedDates)
                      
                      let (selected, start, end) = periodManager.insertDatesBetweenFirstAndLast(
                        from: (calendar.date(from: startDate!)!),
                        to: (calendar.date(from: endDate!)!)
                      )
                      duration = periodManager.countDuration(startDate: start, endDate: end)
                      cycleLength = periodManager.countCycleLength(newStartDate: start)!
                      
                      period = Period(startDate: start, endDate: end, duration: duration, cycleLength: cycleLength)
                      selectedDates.formUnion(selected)
                  }
          }
          .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    if let period = period {
                        periods.append(period)
                    }
                    
                    // Calculate for the next period prediction
                    let answers: [Answer] = [
                      Answer(promptID: 0, answer: DateAnswer(date: calendar.date(from: endDate!)!)),
                      Answer(promptID: 1, answer: NumericAnswer(number: duration!)),
                      Answer(promptID: 2, answer: NumericAnswer(number: cycleLength!)),
                    ]
                    
                    for answer in answers {
                        answerManager.saveOrUpdateAnswer(answer: answer)
                    }
                    answerManager.addCycleLength(cycleLength!)
                    answerManager.calculatePeriodDate()
                    answerManager.calculatePredictedDates()
                    
                    print(period!)
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
    
    // Get bounds from the latest Period data
    var bounds: PartialRangeFrom<Date>? {
        guard let latestPeriod = periodManager.periods.last else {
            return nil // Return nil if there are no periods available
        }

        let monthOfLastPeriod = calendar.date(from: calendar.dateComponents([.year, .month], from: latestPeriod.startDate))!
        let monthOfNextPeriod = calendar.date(byAdding: DateComponents(month: 1), to: monthOfLastPeriod)!
        
        return monthOfNextPeriod...
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
}

//struct AddPeriod_Previews: PreviewProvider {
//    static var previews: some View {
////        AddPeriod()
//    }
//}
