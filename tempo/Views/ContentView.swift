//
//  ContentView.swift
//  tempo
//
//  Created by VegaPunk on 09/04/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var coredataItems: [AppEntity] = []
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationView {
            List {
                ForEach(coredataItems) { coredataItem in
                    NavigationLink {
                        if let safeItemIcon = coredataItem.icon, let safeUIImage = UIImage(data: safeItemIcon) {
                            VStack {
                                Text("\(coredataItem.appName ?? "no app name")")
                                Text("Item at \(coredataItem.timestamp!, formatter: itemFormatter)")
                                Image(uiImage: safeUIImage)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                            }
                        } else {
                            Text("fail safeItemIcon")
                        }
                    } label: {
                        Text("\(coredataItem.appName ?? "no app name")")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
        .onAppear {
            fetchCoreData()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
                fetchCoreData()
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
    }
    
    private func fetchCoreData() {
        let fetchRequest: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
        
        do {
            // Récupérer les éléments à partir du contexte CoreData en utilisant la requête de récupération
            coredataItems = try viewContext.fetch(fetchRequest)
        } catch {
            // Gérer les erreurs de récupération des données
            print("Erreur lors de la récupération des données : \(error.localizedDescription)")
        }
    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = AppEntity(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { coredataItems[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
