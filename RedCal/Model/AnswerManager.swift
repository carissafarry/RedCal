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
    @Published var answers: [Answer] = []
    @Published var startDatePrediction: Date? = nil
    @Published var finishDatePrediction: Date? = nil
    
    func addAnswer(_ answer: Answer) {
        answers.append(answer)
    }
    
    func updateAnswer(at index: Int, with newAnswer: Answer) {
        guard index >= 0, index < answers.count else {
            return
        }
        answers[index] = newAnswer
    }
    
    func calculatePeriodDate(){
        print(answers)
        
        guard let lastPeriodAnswer = getLastPeriodAnswer(),
              let cycleLengthAnswer = getCycleLengthAnswer(),
              let periodDurationAnswer = getPeriodDurationAnswer()
        else {
            return
        }

        if let lastPeriodDate = (lastPeriodAnswer.answer as? DateAnswer)?.date,
           let cycleLength = (cycleLengthAnswer.answer as? NumericAnswer)?.number,
           let periodDuration = (periodDurationAnswer.answer as? NumericAnswer)?.number
        {
            print("Start Date Prediction:")
            let predictedStartDate = Calendar.current.date(byAdding: .day, value: cycleLength, to: lastPeriodDate)!
            print(predictedStartDate)
            
            print("End Date Prediction:")
            let predictedEndDate = Calendar.current.date(byAdding: .day, value: periodDuration, to: predictedStartDate)!
            print(predictedEndDate)
            
            return
        }
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
