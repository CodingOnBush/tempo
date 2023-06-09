//
//  tempoApp.swift
//  tempo
//
//  Created by VegaPunk on 09/04/2023.
//

import SwiftUI

@main
struct tempoApp: App {
    let viewContext = PersistenceController.shared.container.viewContext
    
    var body: some Scene {
        WindowGroup {
            AppLibrary()
                .environment(\.managedObjectContext, viewContext)
                .environmentObject(AppViewModel())
        }
    }
}
