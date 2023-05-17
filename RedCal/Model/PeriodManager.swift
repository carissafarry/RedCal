//
//  PeriodManager.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 12/05/23.
//

import SwiftUI

struct Period: Hashable {
    var startDate: Date
    var endDate: Date
    var duration: Int?
    var cycleLength: Int?
}

class PeriodManager: ObservableObject {
    @Published var periods: [Period] = []
    
    func addPeriod(_ period: Period) {
        periods.append(period)
    }
    
    func insertDatesBetweenFirstAndLast(from firstDate: Date, to lastDate: Date) -> ([DateComponents], Date, Date) {
        let calendar = Calendar.current
        
        let startDate = calendar.startOfDay(for: firstDate)
        var startDateIterator = calendar.startOfDay(for: firstDate)
        let endDate = calendar.startOfDay(for: lastDate)
        
        print(startDate)
        print(endDate)
        print("\n")
        
        var selected: [DateComponents] = []
        
        while startDateIterator <= endDate {
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: startDateIterator)
            selected.append(dateComponents)
            startDateIterator = calendar.date(byAdding: .day, value: 1, to: startDateIterator)!
        }
        return (selected, startDate, endDate)
    }
    
    func countDuration(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day!
    }
    
    func countCycleLength(newStartDate: Date) -> Int? {
        guard let lastPeriod = periods.last else {
            return nil
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastPeriod.endDate, to: newStartDate)
        
        return components.day
    }
}
