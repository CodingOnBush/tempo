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

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<AppModelItem>

    var body: some View {
        NavigationView {
            VStack {
//                NavigationLink(destination: AppInfoView(stringAppId: "1452526406")) {
//                    Label("Open view", systemImage: "plus.circle")
//                }
//                NavigationLink(destination: RootView()) {
//                    Label("Open view", systemImage: "plus.square")
//                }
//                Button(action: addItem) {
//                    Label("Add Item", systemImage: "plus")
//                }
                
                List {
                    ForEach(items) { item in
                        Text("app name : \(item.trackName!)")
//                        NavigationLink {
//                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                        } label: {
//                            Text("\(item.trackName!)")
//                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }.onAppear {
                print("first app : \(String(describing: self.items.first?.trackName))")
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
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
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
