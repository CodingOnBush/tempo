//
//  AppViewModel.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import SwiftUI
import CoreData

class AppViewModel: ObservableObject {
//    @Environment(\.managedObjectContext) private var viewContext
    private (set) var viewContext: NSManagedObjectContext
    @Published var apps: [AnApp] = []
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchData()
    }
    
    func fetchData() {
        print("viewContext = \(self.viewContext.description)")
        
        let fetchRequest: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
        
        do {
            // Récupérer les éléments à partir du contexte CoreData en utilisant la requête de récupération
            let coredataItems = try viewContext.fetch(fetchRequest)
            print("Data found from CoreData ! \(coredataItems.count)")
            
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
}
