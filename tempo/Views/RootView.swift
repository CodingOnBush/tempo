//
//  RootView.swift
//  tempo
//
//  Created by VegaPunk on 26/04/2023.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case library
    case settings
}

struct RootView: View {
    @State private var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
        }
        .onAppear() {
            print("selected tab : \(selectedTab)")
        }
        .onChange(of: selectedTab) { newValue in
            print("selected tab : \(selectedTab)")
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
