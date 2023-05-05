//
//  AppInfoFetched.swift
//  tempo
//
//  Created by VegaPunk on 23/04/2023.
//

import Foundation

struct AppInfoFetched: Codable {
    let resultCount: Int
    let results: [AppDetails]
}

struct AppDetails: Codable {
    let trackName: String?
    let description: String?
    let version: String?
    let sellerName: String?
    let artworkUrl512: URL?
    let trackId: Int?
    let primaryGenreName: String?
    let primaryGenreId: Int?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let price: Float?
    let sellerUrl: String?
    let screenshotUrls: [String]?
    let releaseNotes: String?
    let currentVersionReleaseDate: String?
//    let artistName: String?
//    let genres: [String]?
//    let minimumOsVersion: String?
//    let fileSizeBytes: String?
//    let supportedDevices: [String]?
//    let ipadScreenshotUrls: [String]?
//    let appletvScreenshotUrls: [String]?
//    let languageCodesISO2A: [String]?
//    let contentAdvisoryRating: String?
//    let trackViewUrl: String?
//    let trackContentRating: String?
//    let formattedPrice: String?
//    let currency: String?
//    let bundleId: String?
//    let isVppDeviceBasedLicensingEnabled: Bool?
//    let releaseDate: String?
//    let sellerId: Int?
//    let artistId: Int?
//    let artistViewUrl: String?
//    let advisoryRating: String?
//    let features: [String]?
//    let supportedCountries: [String]?
//    let kind: String?
//    let trackCensoredName: String?
//    let trackViewUrlComponents: URLComponents?
//    let userRatingCountForCurrentVersion: Int?
//    let averageUserRatingForCurrentVersion: Float?
//    let isGameCenterEnabled: Bool?
//    let hasWatchKitExtension: Bool?
//    let watchKitExtensionSupportedDevices: [String]?
//    let watchKitAppVersion: String?
//    let watchKitAppExecutableURL: String?
//    let watchKitAppExecutableArchitecture: String?
//    let appletvPrivacyPolicyURL: String?
//    let appletvPrivacyPolicyText: String?
//    let appletvSiriEnabled: Bool?
//    let appletvSiriExplicitEnabled: Bool?
//    let genreIds: [String]?
//    let featuresString: String?
}
