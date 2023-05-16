//
//  PeriodManager.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 12/05/23.
//

import SwiftUI

struct Period {
    var startDate: Date
    var endDate: Date
    var duration: Int?
    var cycleLength: Int?
}

class PeriodManager: ObservableObject {
    @Published var periods: [Period] = []
    
    func addPeriod(_ period: Period) {
        periods.append(period)
        print(periods)
    }
}
