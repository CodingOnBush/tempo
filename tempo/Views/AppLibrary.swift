//
//  AppLibrary.swift
//  tempo
//
//  Created by VegaPunk on 01/06/2023.
//

import SwiftUI

struct AppLibrary: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AppLibrary_Previews: PreviewProvider {
    static var previews: some View {
        AppLibrary()
    }
}
