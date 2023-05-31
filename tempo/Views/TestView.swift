//
//  TestView.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import SwiftUI

struct TestView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private var appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var body: some View {
        VStack {
            ForEach(self.appViewModel.apps) { app in
                Text("Hello \(app.name)")
            }
        }
        .onAppear {
//            self.appViewModel.fetchData()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(appViewModel: AppViewModel(viewContext: PersistenceController.shared.container.viewContext))
    }
}
