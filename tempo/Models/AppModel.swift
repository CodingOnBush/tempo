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
    
    
    init(trackName: String? = nil, description: String? = nil, version: String? = nil, sellerName: String? = nil, artworkUrl512: URL? = nil, trackId: Int? = nil, primaryGenreName: String? = nil, primaryGenreId: Int? = nil, averageUserRating: Double? = nil, userRatingCount: Int? = nil, price: Float? = nil, sellerUrl: String? = nil, screenshotUrls: [String]? = nil, releaseNotes: String? = nil, currentVersionReleaseDate: String? = nil, appIcon: Image? = nil, appIconUIImage: UIImage? = nil, appstoreURL: URL? = nil, isValidURL: Bool? = nil, artworkURLString: String? = nil) {
        self.trackName = trackName
        self.description = description
        self.version = version
        self.sellerName = sellerName
        self.artworkUrl512 = artworkUrl512
        self.trackId = trackId
        self.primaryGenreName = primaryGenreName
        self.primaryGenreId = primaryGenreId
        self.averageUserRating = averageUserRating
        self.userRatingCount = userRatingCount
        self.price = price
        self.sellerUrl = sellerUrl
        self.screenshotUrls = screenshotUrls
        self.releaseNotes = releaseNotes
        self.currentVersionReleaseDate = currentVersionReleaseDate
        self.appIcon = appIcon
        self.appIconUIImage = appIconUIImage
        self.appstoreURL = appstoreURL
        self.isValidURL = isValidURL
        self.artworkURLString = artworkURLString
    }
    
    init(coredataItem: AppEntity) {
        self.trackName = coredataItem.appName
        self.description = ""
        self.version = ""
        self.sellerName = ""
        self.artworkUrl512 = nil
        self.trackId = 0
        self.primaryGenreName = ""
        self.primaryGenreId = 0
        self.averageUserRating = 0
        self.userRatingCount = 0
        self.price = 0
        self.sellerUrl = ""
        self.screenshotUrls = nil
        self.releaseNotes = ""
        self.currentVersionReleaseDate = ""
        
        if let safeItemIcon = coredataItem.icon, let safeUIImage = UIImage(data: safeItemIcon) {
            self.appIconUIImage = safeUIImage
            self.appIcon = Image(uiImage: safeUIImage)
        }
        
        self.appstoreURL = nil
        self.isValidURL = true
        self.artworkURLString = ""
    }
}
