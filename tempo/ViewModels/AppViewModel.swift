//
//  AppViewModel.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import SwiftUI
import CoreData

class AppViewModel: ObservableObject {
    var persistence = PersistenceController.shared
    @Published var apps: [AnApp] = []
    @Published var coredataItems: [AppEntity] = []
    @State var homeAppSearch: String = ""
    var appsUpdated = false
    @Published var filteredItems: [AnApp] = []
    
    init() {
        self.fetchData()
    }
    
    func makeFilter(search: String) {
        self.filteredItems = []
        for app in apps {
            if app.name.contains(search) {
                self.filteredItems.append(app)
            }
        }
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
        
        do {
            // Récupérer les éléments à partir du contexte CoreData en utilisant la requête de récupération
            self.coredataItems = try persistence.container.viewContext.fetch(fetchRequest)
            print("Data found from CoreData ! \(coredataItems.count)")
            
            self.apps = []
            
            for item in coredataItems {
                if let safeAppName = item.appName, let safeAppIcon = item.icon, let safeID = item.id {
                    let newApp = AnApp(id: safeID, name: safeAppName, icon: UIImage(data: safeAppIcon)!, createdAt: item.timestamp ?? Date.now)
                    self.apps.append(newApp)
                }
            }
            
            self.appsUpdated = false
        } catch {
            // Gérer les erreurs de récupération des données
            print("Erreur lors de la récupération des données : \(error.localizedDescription)")
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { coredataItems[$0] }.forEach(self.persistence.container.viewContext.delete)
            
            offsets.map { index in
                if let appID = coredataItems[index].id {
                    removeApp(id: appID)
                }
            }
            
            do {
                try self.persistence.container.viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func addApp(name: String, icon: UIImage) {
        let newApp = AnApp(id: UUID(), name: name, icon: icon, createdAt: Date.now)
        self.apps.append(newApp)
        
        let entity = AppEntity(context: self.persistence.container.viewContext)
        entity.appName = name
        entity.icon = icon.pngData()
        entity.id = newApp.id
        
        do {
            try self.persistence.container.viewContext.save()
            print("App added and data saved to CoreData!")
        } catch {
            // Gérer les erreurs lors de la sauvegarde des données
            print("Erreur lors de la sauvegarde des données : \(error.localizedDescription)")
        }
    }
    
    func removeApp(id: UUID) {
        apps.removeAll { $0.id == id }
        
        let fetchRequest: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        do {
            let results = try self.persistence.container.viewContext.fetch(fetchRequest)
            if let appEntity = results.first {
                self.persistence.container.viewContext.delete(appEntity)
                try self.persistence.container.viewContext.save()
                print("App removed and data saved to CoreData!")
            }
        } catch {
            // Gérer les erreurs lors de la suppression des données
            print("Erreur lors de la suppression des données : \(error.localizedDescription)")
        }
    }
    
    func updateApp(at index: Int, newName: String, newIcon: UIImage) {
//        var app = apps[index]
//        app.name = newName
//        app.icon = newIcon
//
//        let fetchRequest: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "appName == %@", app.name)
//
//        do {
//            let results = try viewContext.fetch(fetchRequest)
//            if let appEntity = results.first {
//                appEntity.appName = newName
//                appEntity.icon = newIcon.pngData()
//                try viewContext.save()
//                print("App updated and data saved to CoreData!")
//            }
//        } catch {
//            // Gérer les erreurs lors de la mise à jour des données
//            print("Erreur lors de la mise à jour des données : \(error.localizedDescription)")
//        }
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
            try self.persistence.container.viewContext.execute(batchDeleteRequest)
            self.apps = [] // Réinitialiser le tableau des apps
            print("Data cleared from CoreData!")
        } catch {
            // Gérer les erreurs lors de la suppression des données
            print("Erreur lors de la suppression des données : \(error.localizedDescription)")
        }
    }
}
