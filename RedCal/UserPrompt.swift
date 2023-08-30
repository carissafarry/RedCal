//
//  UserPrompt.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 08/05/23.
//

import SwiftUI

struct Prompt {
    let question: String
    let answerInputType: AnswerInputType
}

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height


struct UserPrompt: View {
    @State private var currentCardIndex = 0
    
    @State var prompts: [Prompt] = [
        Prompt(
            question: "When is your last period date?",
            answerInputType: .date
        ),
        Prompt(
            question: "How much your usual period duration?",
            answerInputType: .number
        ),
        Prompt(
            question: "How much your usual period cycle length?",
            answerInputType: .number
        ),
    ]
    
    @State var answers: [Answer] = []
    
    var body: some View {
        VStack {
            TabView(selection: $currentCardIndex) {
                ForEach((prompts.indices), id: \.self) { index in
                    PromptCard(prompts: $prompts, currentCardIndex: $currentCardIndex)
                }
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
        .background(Color(hex: "FEF0F0"))
    }
    
    func slideCardLeft() {
        withAnimation {
            currentCardIndex -= 1
        }
    }
    
    func slideCardRight() {
        withAnimation {
            currentCardIndex += 1
        }
    }
}


struct PromptCard: View {
    @Binding var prompts: [Prompt]
    @Binding var currentCardIndex: Int
    @EnvironmentObject var answerManager: AnswerManager
    @EnvironmentObject var periodManager: PeriodManager
    
    @State var dateAnswer = Date.now
    @State var numberAnswer = -1
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(30)
                .padding(.vertical, screenWidth * 0.05)
                .frame(width:screenWidth * 0.8, height: screenHeight * 0.7)
                .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 0)
            
            VStack {
                Text(prompts[currentCardIndex].question)
                    .foregroundColor(.black)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, screenWidth * 0.15)
                
                // Conditional picker and selection for data saving
                switch prompts[currentCardIndex].answerInputType {
                case .date:
                    DatePicker("", selection: $dateAnswer, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .frame(maxHeight: 400)
                        .labelsHidden()
                    
                case .number:
                    Picker("", selection: $numberAnswer) {
                        ForEach(1...30, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .frame(maxHeight: 400)
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .padding(.horizontal, screenWidth * 0.1)
                }
                
                Button(action: {
                    let answer: Answer
                    
                    switch prompts[currentCardIndex].answerInputType {
                    case .date:
                        answer = Answer(promptID: currentCardIndex, answer: DateAnswer(date: dateAnswer))
                    case .number:
                        answer = Answer(promptID: currentCardIndex, answer: NumericAnswer(number: numberAnswer))
                    }
                    
                    answerManager.saveOrUpdateAnswer(answer: answer)
                    
                    if currentCardIndex < (prompts.count - 1) {
                        currentCardIndex += 1
                    }
                }) {
                    if currentCardIndex < (prompts.count - 1) {
                        ZStack {
                            Rectangle ()
                                .frame(width: screenWidth * 0.65, height: screenHeight * 0.05)
                                .cornerRadius(10)
                            
                            Text("Save")
                                .foregroundColor(.white)
                        }
                    } else {
                        NavigationLink(
                            destination: MainView()
                                .environmentObject(answerManager)
                                .environmentObject(periodManager)
                                .navigationBarBackButtonHidden(true)
                        ) {
                            ZStack {
                                Rectangle ()
                                    .frame(width: screenWidth * 0.65, height: screenHeight * 0.05)
                                    .cornerRadius(10)
                                    .foregroundColor(.green)
                                
                                Text("Next")
                                    .foregroundColor(.white)
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            // Add last prompt to answers data
                            let answer: Answer
                            answer = Answer(promptID: currentCardIndex, answer: NumericAnswer(number: numberAnswer))
                            
                            answerManager.saveOrUpdateAnswer(answer: answer)
                            
                            // Save cycle length data
                            let lastPeriodAnswer = answerManager.getLastPeriodAnswer()
                            let periodDurationAnswer = answerManager.getPeriodDurationAnswer()
                            let cycleLengthAnswer = answerManager.getCycleLengthAnswer()
                            let startDatePeriod = answerManager.getStartDateOfLastPeriod()
                            
                            if let cycleLength = (cycleLengthAnswer!.answer as? NumericAnswer)?.number {
                                answerManager.addCycleLength(cycleLength)
                            }
                            
                            // Calculate the next prediction
                            answerManager.calculatePeriodDate()
                            answerManager.calculatePredictedDates()
                            
                            // Add answer data as the first period data
                            if let lastPeriodDate = (lastPeriodAnswer!.answer as? DateAnswer)?.date,
                               let cycleLength = (cycleLengthAnswer!.answer as? NumericAnswer)?.number,
                               let periodDuration = (periodDurationAnswer!.answer as? NumericAnswer)?.number {
                                let firstPeriod = Period(
                                    startDate: startDatePeriod!,
                                    endDate: lastPeriodDate,
                                    duration: periodDuration,
                                    cycleLength: cycleLength
                                )
                                periodManager.addPeriod(firstPeriod)
                            }
                        })
                        
                    }
                }
                .background(Color(hex: "FEF0F0"))
            }
        }
    }
}

struct UserPrompt_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var answerManager = AnswerManager()
        @StateObject var periodManager = PeriodManager()
        
        UserPrompt()
            .environmentObject(answerManager)
            .environmentObject(periodManager)
    }
}
