//
//  ContentView.swift
//  tempo
//
//  Created by VegaPunk on 09/04/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        NavigationView {
            VStack {
                Text("Data").font(.largeTitle)
//                NavigationLink(destination: AppInfoView(stringAppId: "1452526406")) {
//                    Label("Open view", systemImage: "plus.circle")
//                }
//                NavigationLink(destination: RootView()) {
//                    Label("Open view", systemImage: "plus.square")
//                }
//                Button(action: addItem) {
//                    Label("Add Item", systemImage: "plus")
//                }
                
            }.onAppear {
//
            }
        }
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
