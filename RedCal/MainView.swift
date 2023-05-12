//
//  MainView.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 09/05/23.
//

import SwiftUI

struct MainView: View {
    @Environment(\.calendar) var calendar
    
    @State private var predictedDates: Set<DateComponents> = []
    
    var body: some View {
        ScrollView {
            periodPrediction()
            
//            Button(action: {
//                print("asdasd")
//
//            }, label: {
//                Text("save")
//                }
//            )
        }
    }
    
//    var bounds: PartialRangeFrom<Date> {
    var bounds: Range<Date> {
        let start = calendar.date(from: DateComponents(year: 2023, month: 5, day: 6))!
        let end = calendar.date(from: DateComponents(year: 2023, month: 5, day: 16))!
        
        return start ..< end
    }
    
    func periodPrediction() -> some View {
         
         HStack {
            Section {
                VStack {
                    HStack {
                        Text("Period Prediction")
                            .font(.body)
//                                .background(.red)
                        
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
                        
                        
                        // Display the selected dates
//                        Text("Selected Dates:")
//                        ForEach(predictedDates, id: \.self) { date in
//                            Text(dateFormatter.string(from: date))
//                        }
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
