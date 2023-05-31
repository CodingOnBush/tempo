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
            HomeView(appViewModel: AppViewModel(viewContext: self.viewContext))
                .tabItem {
                    Image(systemName: "house")
                    Text("Home4")
                }
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
    }
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
