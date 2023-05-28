//
//  tempoApp.swift
//  tempo
//
//  Created by VegaPunk on 09/04/2023.
//

import SwiftUI

@main
struct tempoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
