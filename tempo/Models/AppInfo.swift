//
//  AppInfo.swift
//  tempo
//
//  Created by VegaPunk on 30/04/2023.
//

import SwiftUI

class AppInfo: ObservableObject {
    @Published var name: String?
    @Published var description: String?
    @Published var version: String?
    @Published var sellerName: String?
    @Published var artworkURLString: String?
    @Published var id: String?
    @Published var appIcon: Image?
    @Published var appstoreURL: URL?
    @Published var appIconStringURL: String?
}
