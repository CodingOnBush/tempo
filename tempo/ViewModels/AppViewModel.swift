//
//  AppViewModel.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import SwiftUI
import CoreData

class AppViewModel: ObservableObject {
    var viewContext: NSManagedObjectContext
    @Published var apps: [AnApp] = []
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchData()
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
        
        do {
            // Récupérer les éléments à partir du contexte CoreData en utilisant la requête de récupération
            let coredataItems = try viewContext.fetch(fetchRequest)
            print("Data found from CoreData ! \(coredataItems.count)")
            
            self.apps = []
            
            for item in coredataItems {
                if let safeAppName = item.appName, let safeAppIcon = item.icon {
                    let newApp = AnApp(name: safeAppName, icon: UIImage(data: safeAppIcon)!)
                    self.apps.append(newApp)
                }
            }
            
        } catch {
            // Gérer les erreurs de récupération des données
            print("Erreur lors de la récupération des données : \(error.localizedDescription)")
        }
    }
    
    func addApp(name: String, icon: UIImage) {
        let newApp = AnApp(name: name, icon: icon)
        self.apps.append(newApp)
        
        let entity = AppEntity(context: viewContext)
        entity.appName = name
        entity.icon = icon.pngData()
        
        do {
            try viewContext.save()
            print("App added and data saved to CoreData!")
        } catch {
            // Gérer les erreurs lors de la sauvegarde des données
            print("Erreur lors de la sauvegarde des données : \(error.localizedDescription)")
        }
    }
    
    func removeApp(at index: Int) {
        let app = apps[index]
        apps.remove(at: index)
        
        let fetchRequest: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "appName == %@", app.name)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let appEntity = results.first {
                viewContext.delete(appEntity)
                try viewContext.save()
                print("App removed and data saved to CoreData!")
            }
        } catch {
            // Gérer les erreurs lors de la suppression des données
            print("Erreur lors de la suppression des données : \(error.localizedDescription)")
        }
    }
    
    func updateApp(at index: Int, newName: String, newIcon: UIImage) {
        var app = apps[index]
        app.name = newName
        app.icon = newIcon
        
        let fetchRequest: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "appName == %@", app.name)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let appEntity = results.first {
                appEntity.appName = newName
                appEntity.icon = newIcon.pngData()
                try viewContext.save()
                print("App updated and data saved to CoreData!")
            }
        } catch {
            // Gérer les erreurs lors de la mise à jour des données
            print("Erreur lors de la mise à jour des données : \(error.localizedDescription)")
        }
    }
    
//    func updateLocalStorage() {
//        for app in apps {
//            let entity = AppEntity(context: viewContext)
//            entity.appName = app.name
//            entity.icon = app.icon.pngData()
//        }
//        
//        do {
//            try viewContext.save()
//            print("Data saved to CoreData!")
//        } catch {
//            // Gérer les erreurs lors de la sauvegarde des données
//            print("Erreur lors de la sauvegarde des données : \(error.localizedDescription)")
//        }
//    }
    
    func emptyLocalStorage() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "AppEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(batchDeleteRequest)
            self.apps = [] // Réinitialiser le tableau des apps
            print("Data cleared from CoreData!")
        } catch {
            // Gérer les erreurs lors de la suppression des données
            print("Erreur lors de la suppression des données : \(error.localizedDescription)")
        }
    }
}
