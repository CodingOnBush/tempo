//
//  AnApp.swift
//  tempo
//
//  Created by VegaPunk on 31/05/2023.
//

import UIKit

struct AnApp: Identifiable {
    let id = UUID()
    let name: String
    let icon: UIImage
//    let appstoreURL: String
    
    init(name: String, icon: UIImage) {
        self.name = name
        self.icon = icon
//        self.appstoreURL = appstoreURL
    }
}
