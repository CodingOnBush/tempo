//
//  ShareSheetSwiftUIView.swift
//  sharetempo
//
//  Created by VegaPunk on 03/05/2023.
//

import Foundation
import SwiftUI

//En utilisant la bibliothèque SwiftUI et le framework Combine, on peut utiliser un `@State` variable avec le type `Task<Output, Failure>` pour représenter un état d'une tâche asynchrone.
//
//Les différents états sont :
//
//- `idle` : l'état initial de la tâche, où rien ne s'est encore passé
//- `running` : l'état où la tâche est en cours d'exécution
//- `success(Output)` : l'état où la tâche a réussi et a produit une valeur de type `Output`
//- `failure(Failure)` : l'état où la tâche a échoué et a produit une erreur de type `Failure`
//
//Ces états peuvent être utilisés pour mettre à jour l'interface utilisateur en fonction de l'état de la tâche asynchrone. Par exemple, on peut afficher un indicateur de chargement quand la tâche est en cours d'exécution (`running`), afficher le résultat de la tâche quand elle a réussi (`success`), ou afficher un message d'erreur quand elle a échoué (`failure`).

enum ViewState {
    case idle
    case loading
    case loaded
    case noURL
}

struct ShareSheetView: View {
    var context: NSExtensionContext?
    @StateObject var currentApp = AppModel()
    @State var isValidURL: Bool = false
    @State var viewState: ViewState = .idle
    
    var body: some View {
        ZStack {
            if self.isValidURL == false {
                WrongURLView()
            } else {
                switch self.viewState {
                case .idle, .loading:
                    ProgressView()
                case .loaded:
                    AddingAppView(app: currentApp)
                default:
                    ProgressView()
                }
            }
        }.onAppear {
            self.viewState = .loading
            self.loadMaxData()
        }
    }
    
    func loadImage(from url: URL?) {
        if let safeURL = url {
            URLSession.shared.dataTask(with: safeURL) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.currentApp.appIcon = Image(uiImage: UIImage(data: data)!)
                }
            }.resume()
        }
    }
    
    private func fetchAppData(from appURL: URL) {
        if let appID = self.extractIdFromLink(appURL.absoluteString) {
            if let url = URL(string: "https://itunes.apple.com/lookup?id=\(appID)") {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let safeData = data {
                        do {
                            let appInfoDecoded = try JSONDecoder().decode(AppInfoFetched.self, from: safeData)
                            let appDetailsFetched = appInfoDecoded.results.first
                            
                            self.currentApp.name = appDetailsFetched?.trackName
                            self.currentApp.description = appDetailsFetched?.description
                            self.currentApp.version = appDetailsFetched?.version
                            self.currentApp.sellerName = appDetailsFetched?.sellerName
                            
                            self.currentApp.iconURL = appDetailsFetched?.artworkUrl512
                            self.currentApp.id = appDetailsFetched?.trackId
                            self.currentApp.primaryGenreName = appDetailsFetched?.primaryGenreName
                            self.currentApp.primaryGenreId = appDetailsFetched?.primaryGenreId
                            self.currentApp.averageUserRating = appDetailsFetched?.averageUserRating
                            
                            self.currentApp.userRatingCount = appDetailsFetched?.userRatingCount
                            self.currentApp.price = appDetailsFetched?.price
                            self.currentApp.sellerUrl = appDetailsFetched?.sellerUrl
                            self.currentApp.screenshotUrls = appDetailsFetched?.screenshotUrls
                            self.currentApp.lastReleaseNotes = appDetailsFetched?.currentVersionReleaseDate
                            self.currentApp.lastReleaseDate = appDetailsFetched?.currentVersionReleaseDate
                            
                            self.loadImage(from: self.currentApp.iconURL)
                            
                            self.viewState = .loaded
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }.resume()
            }
        }
    }
    
    private func extractIdFromLink(_ link: String) -> String? {
        if let range = link.range(of: "id\\d+", options: .regularExpression) {
            return String(link[range].dropFirst(2))
        }
        return nil
    }
    
    private func loadMaxData() {
        if let safeContext = self.context, let inputItems = safeContext.inputItems as? [NSExtensionItem] {
            for inputItem in inputItems {
                if let attachments = inputItem.attachments {
                    for attachment in attachments {
                        let itemProvider = attachment
                        if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                                if let shareURL = url as? URL {
                                    // Do something with the URL
                                    self.currentApp.appstoreURL = shareURL
                                    self.currentApp.isValidURL = shareURL.absoluteString.hasPrefix("https://apps.apple.com")
                                    self.fetchAppData(from: shareURL)
                                    self.isValidURL = shareURL.absoluteString.hasPrefix("https://apps.apple.com")
                                }
                            }
                        }
                        if itemProvider.hasItemConformingToTypeIdentifier("public.image") {
                            itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil) { (image, error) in
                                if let shareImage = image as? UIImage {
                                    // Do something with the image
                                    self.currentApp.appIcon = Image(uiImage: shareImage)
                                }
                            }
                        }
                        // Add more conditions for other data types
                    }
                }
            }
        }
    }
}

