//
//  RedCalApp.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 05/05/23.
//

import SwiftUI

@main
struct RedCalApp: App {
    @StateObject var answerManager = AnswerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(answerManager)
        }
    }
}
