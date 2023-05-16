//
//  ContentView.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 05/05/23.
//

import SwiftUI
import CoreData


struct ContentView: View {
    var body: some View {
        NavigationStack {
            UserPrompt()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var answerManager = AnswerManager()
        @StateObject var periodManager = PeriodManager()
        
        ContentView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(answerManager)
            .environmentObject(periodManager)
    }
}
