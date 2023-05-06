//
//  AppModel.swift
//  tempo
//
//  Created by VegaPunk on 30/04/2023.
//

import SwiftUI

class AppModel: ObservableObject {
    @Published var name: String?
    @Published var description: String?
    @Published var version: String?
    @Published var sellerName: String?
    @Published var iconURL: URL?
    @Published var id: Int?
    @Published var primaryGenreName: String?
    @Published var primaryGenreId: Int?
    @Published var averageUserRating: Double?
    @Published var userRatingCount: Int?
    @Published var price: Float?
    @Published var sellerUrl: String?
    @Published var screenshotUrls: [String]?
    @Published var lastReleaseNotes: String?
    @Published var lastReleaseDate: String?
    
    @Published var appIcon: Image?
    @Published var appstoreURL: URL?
    @Published var isValidURL: Bool?
    @Published var artworkURLString: String?
    
}
