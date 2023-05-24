//
//  tempoApp.swift
//  tempo
//
//  Created by VegaPunk on 09/04/2023.
//

import SwiftUI

@main
struct tempoApp: App {
    @StateObject var persistenceManager = PersistenceManager()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            ToDoView()
                .environmentObject(persistenceManager)
        }
    }
}
