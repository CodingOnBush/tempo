//
//  LibraryView.swift
//  tempo
//
//  Created by VegaPunk on 26/04/2023.
//

import SwiftUI

struct LibraryView: View {
    // Injectez l'instance du CoreDataStack
//    @Environment(\.managedObjectContext) private var viewContext
    
    // Créez une requête pour récupérer toutes les instances d'AppModelItem
//    @FetchRequest(sortDescriptors: [])
//    private var items: FetchedResults<AppModelItem>
    
    
    
    var body: some View {
        NavigationView {
            List {
                // Affichez chaque instance dans la liste
//                ForEach(items) { item in
//                    Text(item.trackName ?? "Untitled")
//                }
            }
            .navigationTitle("My Data")
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
