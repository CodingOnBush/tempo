//
//  App.swift
//  tempo
//
//  Created by VegaPunk on 09/05/2023.
//

import Foundation
import SwiftUI

public class AppModel: ObservableObject, Identifiable {
    public var id: UUID = UUID()
    @Published var trackName: String?
    @Published var description: String?
    @Published var version: String?
    @Published var sellerName: String?
    @Published var artworkUrl512: URL?
    @Published var trackId: Int?
    @Published var primaryGenreName: String?
    @Published var primaryGenreId: Int?
    @Published var averageUserRating: Double?
    @Published var userRatingCount: Int?
    @Published var price: Float?
    @Published var sellerUrl: String?
    @Published var screenshotUrls: [String]?
    @Published var releaseNotes: String?
    @Published var currentVersionReleaseDate: String?
    
    @Published var appIcon: Image?
    @Published var appIconUIImage: UIImage?
    @Published var appstoreURL: URL?
    @Published var isValidURL: Bool?
    @Published var artworkURLString: String?
    
}
