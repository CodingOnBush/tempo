//
//  MainView.swift
//  tempo
//
//  Created by VegaPunk on 26/05/2023.
//

import SwiftUI

struct MainView: View {
//    var coreDataViewContext = PersistenceController.shared.container.viewContext
    
//    var myCoreData = CoreData.shared
    
    @State var anItem = "none"
    
    var items = ["hey"]
    
//    @FetchRequest(
//        entity: ToDoItem.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.taskDescription, ascending: true)]
//    ) var items: FetchedResults<ToDoItem>
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(anItem)
//                Button {
//                    myCoreData.getStoredDataFromCoreData()
//                    self.anItem = myCoreData.items.first ?? "no item found"
//                } label: {
//                    Text("RELOAD").padding()
//                }

                Button {
//                    let newToDo = ToDoItem(context: myCoreData.persistentContainer.viewContext)
//
//                    newToDo.isCompleted = false
//                    newToDo.taskDescription = "no app name found"
//
//                    do {
//                        try myCoreData.saveContext()
//                    } catch {
//                        print("error viewContext.save()")
//                    }
                } label: {
                    Text("NEW")
                }

                Text("nb : \(items.count)")
//                List {
//                    ForEach(items) { item in
//                        Text("item : \(item)")
//                    }
//                }
            }
            .navigationTitle(Text("Liste"))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
