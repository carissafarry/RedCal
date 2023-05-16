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
    
    @State private var predictedDates: Set<DateComponents> = []
    
    @State private var isAddPeriod = false
    
    // TODO: Replace with cycle data
    
    let chartData: [CGFloat] = [40, 29, 30, 30, 31, 28, 29]
    let chartData2: [Period] = [
        .init(startDate: Date.now, endDate: Date.now, duration: 7, cycleLength: 30)
    ]
    var maxCycleDayLength = 50
    
    var body: some View {
        ScrollView {
            
            header()
            periodPrediction()
            
//            Chartt(periods: periodManager.periods)
            
            CycleLengthChart(data: chartData)
//            CycleLengthChart(data: periodManager.periods)
//                .frame(width: screenWidth)
        }
        .background(Color(hex: "FEF0F0"))
//        .background(Color(hex: "F2F2F6"))
//        .onAppear {
//            print(periodManager.periods)
//        }
    }
        
    
//    @ViewBuilder
//    func Chartt(periods: [Period]) -> AnyView {
////        return
//            VStack {
//                Text("Cycle Length")
//                HStack(alignment:.bottom) {
//                    ForEach(periods, id: \.self) { period in
//                        VStack {
//                            ZStack(alignment:.bottom) {
//                                Rectangle()
//                                    .fill(Color.white)
//                                    .frame(
//                                        width: screenWidth*0.06,
//                                        height: screenWidth*0.5 + 6
//                                    )
//                                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                                    .padding(.horizontal, screenWidth*0.024)
//
//                                Rectangle()
//                                    .fill(Color(hex: "E2DCFE"))
//                                    .frame(
//                                        width: screenWidth*0.045,
//                                        height: period.cycleLength/CGFloat(maxCycleDayLength) * screenWidth*0.5
//                                    )
//                                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                                    .padding(.bottom, 3)
//                            }
//
//                            Text(String(Int(period.cycleLength)))
//                                .font(.caption)
//                        }
//                    }
//                }
//            }
//        .frame(width: screenWidth * 0.93)
//        .background(Color(hex:"F3F3F3"))
//        .onAppear{
////            print(periodManager.periods)
//        }
//    }
    
    var bounds: Range<Date> {
        let start = calendar.date(from: DateComponents(year: 2023, month: 5, day: 6))!
        let end = calendar.date(from: DateComponents(year: 2023, month: 5, day: 16))!
        
        return start ..< end
    }
    
    func header() -> some View {
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
    
    func periodPrediction() -> some View {
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
                
                // TODO: Display highlighted predicted dates
                MultiDatePicker(
                    "Start Date",
                    selection: $predictedDates,
                    in: bounds
                )
                .datePickerStyle(.graphical)
                .disabled(true)
                .accentColor(.red)
                .shadow(radius: 0)
                .onChange(of: predictedDates) { dates in
                    // Perform operations on selected dates
                    // For example, print the selected dates
                    for date in dates {
                        print(date)
                    }
                }
            }
            .padding(.horizontal, screenWidth * 0.05)
        }
//        .background(Color(hex:"F3F3F3"))
        .background(.white)
        .cornerRadius(15)
        .padding(.horizontal, 15)
    }
}

struct CycleLengthChart: View {
    let data: [CGFloat]
//    @State private var data: [Period] = []
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
//                    .background(.red)
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, -screenWidth*0.55)
//            .background(.yellow)
            
            
            HStack(alignment:.bottom) {
                ForEach(Array(data.suffix(7).enumerated()), id: \.offset) { index, value in
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
                                    height: value/CGFloat(maxCycleDayLength) * screenWidth*0.5
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom, 3)
                        }
                        
                        Text(String(Int(value)))
                            .font(.caption)
                    }
                }
            }
            .padding(.vertical, 10)
//            .background(.red)
        }
        .background(Color(hex:"F3F3F3"))
        .cornerRadius(15)
        .padding(.horizontal, 15)
        .onAppear{
//            print(periodManager.periods)
        }
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
