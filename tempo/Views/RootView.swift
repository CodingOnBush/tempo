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
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "1.circle.fill")
                    Text("Premier")
                }
            
            LibraryView()
                .tag("Library")
                .tabItem {
                    Label("Library", systemImage: "square.grid.2x2")
                    Text("Premier")
                }
            
            AppsView()
                .tag("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                    Text("Settings")
                }
        }
        .onAppear() {
            print("selected tab : \(selectedTab)")

//            let standardAppearance = UITabBarAppearance()
//            standardAppearance.backgroundColor = UIColor(Color.gray)
//            standardAppearance.shadowColor = .gray

//            let itemAppearance = UITabBarItemAppearance()
//            itemAppearance.normal.iconColor = UIColor(Color.white)
//            itemAppearance.selected.iconColor = UIColor(Color.red)
//            standardAppearance.inlineLayoutAppearance = itemAppearance
//            standardAppearance.stackedLayoutAppearance = itemAppearance
//            standardAppearance.compactInlineLayoutAppearance = itemAppearance
            
//            UITabBar.appearance().standardAppearance = standardAppearance
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
