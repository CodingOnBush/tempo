//
//  ShareSheetSwiftUIView.swift
//  sharetempo
//
//  Created by VegaPunk on 03/05/2023.
//

import Foundation
import SwiftUI

struct ShareSheetView: View {
    var context: NSExtensionContext?
    @StateObject var appInfo = AppInfo()
    @State var toPrint = "empty"
    
    var body: some View {
        ZStack {
            Color(red: 0.89, green: 0.89, blue: 0.89)
                .ignoresSafeArea()
            VStack {
                Text("print : \(toPrint)")
                HStack {
                    self.appInfo.appIcon?
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(self.appInfo.name ?? "app name")
                            .font(.headline)
                        Text(self.appInfo.appstoreURL?.absoluteString ?? "no url found")
                            .font(.subheadline)
                    }
                    .padding(.leading, 16)
                }
                .padding(18)
                .background(Color.white)
                .cornerRadius(8)
            }
            
        }.onAppear(perform: self.loadMaxData)
    }
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.appInfo.appIcon = Image(uiImage: UIImage(data: data)!)
            }
        }.resume()
    }
    
    private func fetchAppInfo(from appURL: URL) {
        if let appID = self.extractIdFromLink(appURL.absoluteString) {
            if let url = URL(string: "https://itunes.apple.com/lookup?id=\(appID)") {
                let session = URLSession.shared
                let task = session.dataTask(with: url) { data, _, error in
                    if let safeData = data {
                        do {
                            let decoder = JSONDecoder()
                            let appInfoDecoded = try decoder.decode(AppInfoFetched.self, from: safeData)
                            let appInfoFetched = appInfoDecoded.results.first
                            
                            self.appInfo.name = appInfoFetched?.trackName ?? "app name not found"
                            self.appInfo.description = appInfoFetched?.description ?? "app description not found"
                            self.appInfo.version = appInfoFetched?.version ?? "app version not found"
                            self.appInfo.sellerName = appInfoFetched?.sellerName ?? "app seller name not found"
                            self.appInfo.artworkURLString = String(describing: appInfoFetched?.artworkUrl100)
                            self.appInfo.id = String(describing: appInfoFetched?.trackId)
//                            self.appInfo.appIconStringURL = appInfoFetched?.artworkUrl100?.absoluteString
                            
                            if let safeURL = appInfoFetched?.artworkUrl100 {
                                self.loadImage(from: safeURL)
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
                task.resume()
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
                                    self.appInfo.appstoreURL = shareURL
                                    self.fetchAppInfo(from: shareURL)
                                }
                            }
                        }
                        if itemProvider.hasItemConformingToTypeIdentifier("public.image") {
                            itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil) { (image, error) in
                                if let shareImage = image as? UIImage {
                                    // Do something with the image
                                    self.appInfo.appIcon = Image(uiImage: shareImage)
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

