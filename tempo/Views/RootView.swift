//
//  RootView.swift
//  tempo
//
//  Created by VegaPunk on 26/04/2023.
//

import SwiftUI

struct RootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView() {
            TestView(appViewModel: AppViewModel(viewContext: self.viewContext))
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ContentView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
        }
        .edgesIgnoringSafeArea(.bottom)
//        .onAppear {
//            print(self.appViewModel.fetchData())
//        }
    }
}
