//
//  TestView.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import SwiftUI

struct TestView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.scenePhase) var scenePhase
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Spacer()
                Button {
                    self.appViewModel.emptyLocalStorage()
                    self.appViewModel.fetchData()
                } label: {
                    Label("empty coredata storage", systemImage: "trash.circle")
                }
            }

            VStack {
                ForEach(self.appViewModel.apps) { app in
                    Text("Hello \(app.name)")
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
                self.appViewModel.fetchData()
            } else if newPhase == .inactive {
                print("Inactive")
//                self.appViewModel.updateLocalStorage()
                self.appViewModel.fetchData()
            } else if newPhase == .background {
                print("Background")
//                self.appViewModel.updateLocalStorage()
                self.appViewModel.fetchData()
            }
        }
    }
}
