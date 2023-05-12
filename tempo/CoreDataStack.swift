//
//  CoreDataStack.swift
//  tempo
//
//  Created by VegaPunk on 12/05/2023.
//

import CoreData

class CoreDataStack {
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "tempo")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
                print("Erreur lors de l'enregistrement de l'instance dans Core Data : \(error.localizedDescription)")
            }
        }
    }

}
