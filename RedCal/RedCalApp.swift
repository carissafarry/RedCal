//
//  RedCalApp.swift
//  RedCal
//
//  Created by Carissa Farry Hilmi Az Zahra on 05/05/23.
//

import SwiftUI

@main
struct RedCalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
