//
//  AnswerManager.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 11/05/23.
//

import SwiftUI
import Combine

class AnswerManager: ObservableObject {
    @Published var answers: [Answer] = []
    
    func addAnswer(_ answer: Answer) {
        answers.append(answer)
    }
    
    func updateAnswer(at index: Int, with newAnswer: Answer) {
        guard index >= 0, index < answers.count else {
            return
        }
        answers[index] = newAnswer
    }
}
