//
//  MainView.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 09/05/23.
//

import SwiftUI

struct MainView: View {
    @Environment(\.calendar) var calendar
    
    @EnvironmentObject var answerManager: AnswerManager
    @EnvironmentObject var periodManager: PeriodManager
    
    @State private var predictedDates: Set<DateComponents> = []
    
    @State private var isAddPeriod = false
    
    var body: some View {
        ScrollView {
            header()
            periodPrediction()
        }
        .onAppear {
            print(periodManager.periods)
        }
    }
    
//    var bounds: PartialRangeFrom<Date> {
    var bounds: Range<Date> {
        let start = calendar.date(from: DateComponents(year: 2023, month: 5, day: 6))!
        let end = calendar.date(from: DateComponents(year: 2023, month: 5, day: 16))!
        
        return start ..< end
    }
    
    func header() -> some View {
        HStack(alignment:.top) {
            VStack(alignment: .leading) {
                Text("Good Morning")
                    .font(.system(size: 25, weight: .medium, design: .default))
                    .foregroundColor(.gray)
                Text("Jesselyn")
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
                        
                        Text("+")
                            .font(.system(size: 25, weight: .medium, design: .default))
                            .foregroundColor(.black)
                    }
                }
                .sheet(isPresented: $isAddPeriod, content: {
                    AddPeriod()
                })
            }
        }
        .frame(width: screenWidth*0.92)
    }
    
    func periodPrediction() -> some View {
         HStack {
            Section {
                VStack {
                    HStack {
                        Text("Period Prediction")
                            .font(.body)
                        
                        Spacer()
                        Button(action: {}, label: {
                            Text("All >")
                        })
                    }
                    .padding(.top, 35)
                    
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
                        .onChange(of: predictedDates) { dates in
                            // Perform operations on selected dates
                            // For example, print the selected dates
                            for date in dates {
                                print(date)
                            }
                        }
                        .datePickerStyle(.graphical)
                        .accentColor(.pink)
                        .shadow(radius: 0)
                        .padding(.bottom, 20)
                    }
                }
            }
            .padding(.horizontal, screenWidth * 0.05)
            .frame(height: screenHeight*0.42)
            .background(Color(.lightGray))
            .cornerRadius(15)
            .padding(.horizontal, 15)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
