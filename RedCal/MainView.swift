//
//  MainView.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 09/05/23.
//

import SwiftUI
import Charts

import SwiftUI
import Charts


struct MainView: View {
    @Environment(\.calendar) var calendar
    
    @EnvironmentObject var answerManager: AnswerManager
    @EnvironmentObject var periodManager: PeriodManager
    
    @State private var isAddPeriod = false
    
    var maxCycleDayLength = 50
    
    
    var body: some View {
        ScrollView {
            Header()
            PeriodPrediction()
            CycleLengthChart(periods: periodManager.periods)
        }
        .background(Color(hex: "FEF0F0"))
    }
    
    var bounds: Range<Date> {
        let start = calendar.startOfDay(for: answerManager.startDatePrediction!)
        let end = calendar.startOfDay(for: answerManager.finishDatePrediction!)

        return start ..< end
    }
    
    func Header() -> some View {
        HStack(alignment:.top) {
            VStack(alignment: .leading) {
                Text("Good Morning,")
                    .font(.system(size: 35, weight: .medium, design: .default))
                    .foregroundColor(Color(hex: "BE8080"))
                Text("Jesselyn!")
                    .font(.system(size: 35, weight: .medium, design: .default))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            ZStack(alignment:.topTrailing) {
                Button(action: {
                    isAddPeriod = true
                }) {
                    ZStack {
                        Rectangle()
                            .fill(.opacity(0))
                            .frame(width:screenWidth * 0.08, height: screenHeight * 0.05)
                        
                        Image(systemName: "plus.app.fill")
                            .font(.system(size: 30, weight: .medium, design: .default))
                            .foregroundColor(.black)
                    }
                }
                .sheet(isPresented: $isAddPeriod, content: {
                    AddPeriod()
                })
            }
        }
        .frame(width: screenWidth*0.90)
    }
    
    func PeriodPrediction() -> some View {
        VStack {
                HStack {
                    Text("Period Prediction")
                        .font(.body).bold()
                        .foregroundColor(Color(hex: "CE5656"))
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, screenWidth * 0.05)
                .background(.white)
            
//            Rectangle()
//                .frame(height: 0.1)
//                    .foregroundColor(.black)
//                    .padding(.top, -10)

            ZStack {
                Rectangle()
                    .frame(height: 300)
                    .foregroundColor(.white)
                    .padding(.bottom, 25)
                
                MultiDatePicker(
                    "Start Date",
                    selection: $answerManager.predictedDates,
                    in: bounds
                )
                .datePickerStyle(.graphical)
                .disabled(true)
                .accentColor(.red)
                .shadow(radius: 0)
            }
            .padding(.horizontal, screenWidth * 0.05)
        }
        .background(.white)
        .cornerRadius(15)
        .padding(.horizontal, 15)
    }
}

struct CycleLengthChart: View {
    @State var periods: [Period]
    var maxCycleDayLength = 50

    var body: some View {
        VStack {
            HStack {
                Text("Cycle History")
                    .font(.body).bold()
                    .foregroundColor(Color(hex: "CE5656"))
                
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, screenWidth * 0.05)
            .background(.white)
            
            HStack {
                Text("Cycle Length")
                    .font(.title3)
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, -screenWidth*0.55)
            
            HStack(alignment:.bottom) {
                ForEach(Array(periods.suffix(7)), id: \.self) { period in
                    VStack {
                        ZStack(alignment:.bottom) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(
                                    width: screenWidth*0.06,
                                    height: screenWidth*0.5 + 6
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.horizontal, screenWidth*0.024)

                            Rectangle()
                                .fill(Color(hex: "FEDCDC"))
                                .frame(
                                    width: screenWidth*0.045,
                                    height: CGFloat(period.cycleLength!)/CGFloat(maxCycleDayLength)*(screenWidth*0.5)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 3)
                        }

                        Text(String(period.cycleLength!))
                            .font(.caption)
                    }
               }
            }
            .padding(.vertical, 10)
        }
        .background(Color(hex:"F3F3F3"))
        .cornerRadius(15)
        .padding(.horizontal, 15)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var answerManager = AnswerManager()
        @StateObject var periodManager = PeriodManager()
        
        MainView()
            .environmentObject(answerManager)
            .environmentObject(periodManager)
    }
}
