//
//  AnApp.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import UIKit

struct AnApp: Identifiable {
    let id: UUID
    var name: String
    var icon: UIImage
//    let appstoreURL: String
    
    init(id: UUID, name: String, icon: UIImage) {
        self.id = id
        self.name = name
        self.icon = icon
//        self.appstoreURL = appstoreURL
    }
    
    static let sampleApps = [
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!),
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!),
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!),
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!),
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!),
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!)
    ]
}
