//
//  AnApp.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import UIKit

struct AnApp: Identifiable, Hashable {
    let id: UUID
    var name: String
    var icon: UIImage
    var createdAt: Date
//    let appstoreURL: String
    
    init(id: UUID, name: String, icon: UIImage, createdAt: Date) {
        self.id = id
        self.name = name
        self.icon = icon
        self.createdAt = createdAt
//        self.appstoreURL = appstoreURL
    }
    
    static let sampleApps = [
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!, createdAt: Date()),
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!, createdAt: Date()),
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!, createdAt: Date()),
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!, createdAt: Date()),
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!, createdAt: Date()),
        AnApp(id: UUID(), name: "Plantry: Meal Plans & Recipes ", icon: UIImage(named: "Plantry")!, createdAt: Date())
    ]
}
