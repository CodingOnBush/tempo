//
//  ShareSheetSwiftUIView.swift
//  sharetempo
//
//  Created by VegaPunk on 03/05/2023.
//

import SwiftUI
import CoreData

struct ShareSheetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var context: NSExtensionContext?
    @StateObject var currentApp = AppModel()
    @State var isValidURL: Bool = false
    @State var isItemSaved = "nooo"
    
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            VStack {
                ZStack {
                    Color(red: 0.89, green: 0.89, blue: 0.89)
                        .ignoresSafeArea()
                    VStack {
                        Text("is item saved ? \(isItemSaved)")
                        HStack {
                            ZStack {
                                Rectangle().foregroundColor(.gray)
                                self.currentApp.appIcon?.resizable()
                            }
                            .frame(width: 100, height: 100)
                            .cornerRadius(16)
                            .shadow(radius: 5)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(self.currentApp.trackName ?? "app name")
                                    .font(.headline)
                                Text("\(self.currentApp.trackId ?? 0)")
                                    .font(.subheadline)
                            }
                            .padding(.leading, 16)
                        }
                        .padding(18)
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                Button(action: addItem) {
                    ZStack {
                        Color.black
                        Label("Add Item", systemImage: "plus.square")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .frame(width: 130, height: 46)
                    .cornerRadius(8)
                }
            }
            .padding()
        }.onAppear {
            // onAppear triggers actions any time the view appears on screen, even if it’s not the first time.
            self.loadMaxData()
        }.task {
            // task triggers actions that execute asynchronously before the view appears on screen.
            // self.loadMaxData()
        }.onDisappear {
            // onDisappear triggers actions when a view disappears from screen.
        }
        
    }
    
    private func addItem() {
        let newItem = AppEntity(context: viewContext)
        newItem.timestamp = Date()
        newItem.appName = self.currentApp.trackName
        newItem.icon = self.currentApp.appIconUIImage!.pngData()

        do {
            try viewContext.save()
            self.isItemSaved = "yesss"
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func loadImage(from url: URL?) {
        if let safeURL = url {
            URLSession.shared.dataTask(with: safeURL) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.currentApp.appIconUIImage = UIImage(data: data)
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

