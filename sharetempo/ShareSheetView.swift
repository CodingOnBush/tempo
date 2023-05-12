//
//  ShareSheetSwiftUIView.swift
//  sharetempo
//
//  Created by VegaPunk on 03/05/2023.
//

import Foundation
import SwiftUI
import CoreData

enum ViewState {
    case idle
    case loading
    case loaded
    case noURL
}


struct ShareSheetView: View {
    // Enumeration des différents états
    enum MyStates {
        case idle
        case loading
        case viewWillClose
        case error
    }
    
    // Etat initial est "idle"
    @State var state: MyStates = .idle
    
    var context: NSExtensionContext?
    var currentApp = AppModel()
    @State var isValidURL: Bool = false
    @State var viewState: ViewState = .idle
    
    
    var body: some View {
        VStack {
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
        
        Button {
            self.state = .loading
            
            localSaveApp()
//            self.context?.completeRequest(returningItems: nil, completionHandler: nil)
            
            self.state = .viewWillClose
        } label: {
            buttonContent()
                .foregroundColor(.white)
                .padding()
                .background(.purple)
                .cornerRadius(8)
        }
        
    }
    
    private func localSaveApp() {
        // Créer une instance du CoreDataStack
        let coreDataStack = CoreDataStack()
        
        // Créer une instance de votre NSManagedObject
        guard let entity = NSEntityDescription.entity(forEntityName: "AppModelItem", in: coreDataStack.viewContext) else {
            fatalError("Impossible de récupérer l'entité MyEntity")
//            print("Impossible de récupérer l'entité MyEntity")
        }

        let instance = AppModelItem(entity: entity, insertInto: coreDataStack.viewContext)

        instance.timestamp = Date()
        instance.id = self.currentApp.id
        instance.trackName = self.currentApp.trackName
        // ... le faire pour tout

        // Enregistrez les changements dans Core Data
//        coreDataStack.saveContext()
        
        do {
            try coreDataStack.viewContext.save()
            print("SAVED ?")
        } catch let error as NSError {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
            print("Erreur lors de l'enregistrement de l'instance dans Core Data : \(error.localizedDescription)")
        }
    }
    
    private func buttonContent() -> some View {
        switch self.state {
        case .idle:
            return AnyView(Text("Start Loading"))
        case .loading:
            return AnyView(ProgressView())
        case .error:
            return AnyView(Text("Error"))
        case .viewWillClose:
            return AnyView(Text("View closing"))
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
                            let appInfoDecoded = try JSONDecoder().decode(LookupResult.self, from: safeData)
                            let appDetailsFetched = appInfoDecoded.results.first
                            
                            self.currentApp.trackName = appDetailsFetched?.trackName
                            self.currentApp.description = appDetailsFetched?.description
                            self.currentApp.version = appDetailsFetched?.version
                            self.currentApp.sellerName = appDetailsFetched?.sellerName
                            
                            self.currentApp.artworkUrl512 = appDetailsFetched?.artworkUrl512
                            self.currentApp.trackId = appDetailsFetched?.trackId
                            self.currentApp.primaryGenreName = appDetailsFetched?.primaryGenreName
                            self.currentApp.primaryGenreId = appDetailsFetched?.primaryGenreId
                            self.currentApp.averageUserRating = appDetailsFetched?.averageUserRating
                            
                            self.currentApp.userRatingCount = appDetailsFetched?.userRatingCount
                            self.currentApp.price = appDetailsFetched?.price
                            self.currentApp.sellerUrl = appDetailsFetched?.sellerUrl
                            self.currentApp.screenshotUrls = appDetailsFetched?.screenshotUrls
                            self.currentApp.currentVersionReleaseDate = appDetailsFetched?.currentVersionReleaseDate
                            self.currentApp.currentVersionReleaseDate = appDetailsFetched?.currentVersionReleaseDate
                            
                            self.loadImage(from: self.currentApp.artworkUrl512)
                            
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

