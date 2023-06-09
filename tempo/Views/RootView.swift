//
//  RootView.swift
//  tempo
//
//  Created by VegaPunk on 26/04/2023.
//

import SwiftUI

struct RootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedTab = "Apps"
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
//            HomeView(tabSelection: $selectedTab)
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("Home")
//                }
//                .tag("Home")
            AppLibrary()
                .tabItem {
                    Image(systemName: "square.split.1x2.fill")
                    Text("Apps")
                }
                .tag("Apps")
        }
        .edgesIgnoringSafeArea(.bottom)
        .accentColor(.orange)
    }
}
