//
//  formularyApp.swift
//  formulary
//
//  Created by Mael Chariault on 11/08/2023.
//

import SwiftUI

@main
struct formularyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
