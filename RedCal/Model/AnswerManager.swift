//
//  AnswerManager.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 11/05/23.
//

import SwiftUI
import Combine

struct Answer {
    var promptID: Int
    var answer: AnswerType
}

enum AnswerInputType {
    case date
    case number
}

protocol AnswerType {}

struct DateAnswer: AnswerType {
    let date: Date
}

struct NumericAnswer: AnswerType {
    let number: Int
}

class AnswerManager: ObservableObject {
    @Environment(\.calendar) var calendar
    
    @Published var answers: [Answer] = []
    @Published var startDatePrediction: Date? = nil
    @Published var finishDatePrediction: Date? = nil
    @Published var predictedDates: Set<DateComponents> = []
    @Published var cycleLengths: [Int] = []
    
    
    func addAnswer(_ answer: Answer) {
        answers.append(answer)
    }
    
    func updateAnswer(at index: Int, with newAnswer: Answer) {
        guard index >= 0, index < answers.count else {
            return
        }
        answers[index] = newAnswer
    }
    
    func setPredictedDates(selected: [DateComponents]) {
        predictedDates.formUnion(selected)
    }
    
    func saveOrUpdateAnswer(answer: Answer) {        
        if let index = answers.firstIndex(where: { $0.promptID == answer.promptID }) {
            updateAnswer(at: index, with: answer)
        } else {
            addAnswer(answer)
        }
    }
    
    func addCycleLength(_ cycleLength: Int) {
        cycleLengths.append(cycleLength)
    }
    
    func calculateAvgCycleLength() -> Int? {
        guard !cycleLengths.isEmpty else {
            return 0
        }
        
        let total = cycleLengths.reduce(0, +)
        let average = total / cycleLengths.count
        
        return average
    }
    
    func calculatePeriodDate(){
        guard let lastPeriodAnswer = getLastPeriodAnswer(),
              let periodDurationAnswer = getPeriodDurationAnswer()
        else {
            return
        }
        
        if let lastPeriodDate = (lastPeriodAnswer.answer as? DateAnswer)?.date,
           let cycleLength = calculateAvgCycleLength(),
           let periodDuration = (periodDurationAnswer.answer as? NumericAnswer)?.number
        {
            print("Start Date Prediction:")
            startDatePrediction = Calendar.current.date(byAdding: .day, value: cycleLength, to: lastPeriodDate)!
            print(startDatePrediction!)
            
            print("End Date Prediction:")
            finishDatePrediction = Calendar.current.date(byAdding: .day, value: periodDuration, to: startDatePrediction!)!
            print(finishDatePrediction!)
            
            return
        }
    }
    
    func calculatePredictedDates() {
        let calendar = Calendar.current
        
        let (selected, _, _) = insertDatesBetweenFirstAndLast(
            from: (
                calendar.date(from:
                                calendar.dateComponents([.year, .month, .day], from: startDatePrediction!)
                             )!
            ),
            to:(
                calendar.date(from:
                                calendar.dateComponents([.year, .month, .day], from: finishDatePrediction!)
                             )!
            )
        )
        setPredictedDates(selected: selected)
        print("Predicted Dates")
        print(predictedDates)
    }
    
    // TODO: Double function on PeriodManager (cannot access PeriodManager)
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
    
    func getLastPeriodAnswer() -> Answer? {
        if answers.count > 0 {
            return answers.first(where: { $0.promptID == 0 })!
        }
        return nil
    }
    
    func getPeriodDurationAnswer() -> Answer? {
        if answers.count > 0 {
            return answers.first(where: { $0.promptID == 1 })!
        }
        return nil
    }
    
    func getCycleLengthAnswer() -> Answer? {
        if answers.count > 0 {
            return answers.first(where: { $0.promptID == 2 })!
        }
        return nil
    }
    
    func getStartDateOfLastPeriod() -> Date? {
        guard let lastPeriodAnswer = getLastPeriodAnswer(),
              let periodDurationAnswer = getPeriodDurationAnswer()
        else {
            return nil
        }
        
        if let lastPeriodDate = (lastPeriodAnswer.answer as? DateAnswer)?.date,
           let periodDuration = (periodDurationAnswer.answer as? NumericAnswer)?.number,
           answers.count > 0 {
            let adjustedStartDate = Calendar.current.date(byAdding: .day, value: -(periodDuration), to: lastPeriodDate)!
            
            return adjustedStartDate
        }
        return nil
    }
}
