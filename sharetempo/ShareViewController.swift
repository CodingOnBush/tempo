//
//  ShareViewController.swift
//  sharetempo
//
//  Created by VegaPunk on 09/04/2023.
//

import SwiftUI

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Créer une instance de la vue SwiftUI
        let swiftUIView = MySwiftUIView(myNSExtensionContext: self.extensionContext)
        
        // Créer un contrôleur d'hôte SwiftUI
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Ajouter le contrôleur d'hôte SwiftUI à la vue
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
}

struct MySwiftUIView: View {
    @State private var shareURL: URL?
    @State private var dataFetched: String = "loading..."
    var myNSExtensionContext: NSExtensionContext?
    @State var image: Image?
    
    var body: some View {
        VStack {
            Button { getDataFromContext() } label: {
                Text("parse")
            }
            
            Button {
                if let appId = getAppIdFromUrl(shareURL!.absoluteString) {
                    getAppDetails(appId: "\(appId)") { result in
                        switch result {
                        case .success(let data):
                            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let results = json["results"] as? [[String: Any]],
                               let appInfo = results.first {
                                // Process app information here
                                self.dataFetched = "\(appInfo["trackName"] ?? "nothing")"
                            }
                        case .failure(let error):
                            print("Error retrieving app details: \(error.localizedDescription)")
                            self.dataFetched = "Error retrieving app details: \(error.localizedDescription)"
                        }
                    }
                } else {
                    print("Invalid URL")
                    self.dataFetched = "Invalid URL"
                }
            } label: {
                Text("fetch data")
            }
            
            Spacer()
            
            Text(shareURL?.absoluteString ?? "No URL found")
            Text("Fetch data : \(dataFetched)")
            image?
                .resizable()
                .scaledToFit()
        }
    }
    
    func getAppIdFromUrl(_ url: String) -> String? {
        guard let urlComponents = URLComponents(string: url) else {
            self.dataFetched = "YOUHOU1"
            return nil
        }
        let pathComponents = urlComponents.path.split(separator: "/")
        if let appIdComponent = pathComponents.last, appIdComponent != "id" {
            self.dataFetched = String(appIdComponent)
            let numbersOnly = appIdComponent.filter("0123456789".contains)
            return numbersOnly
        }
        self.dataFetched = "YOUHOU3"
        return nil
    }

    
    
    
    func getAppDetails(appId: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = "https://itunes.apple.com/lookup?id=\(appId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
    func getDataFromContext() {
        if let inputItems = myNSExtensionContext?.inputItems as? [NSExtensionItem] {
            for inputItem in inputItems {
                if let attachments = inputItem.attachments {
                    for attachment in attachments {
                        let itemProvider = attachment
                        if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                                if let shareURL = url as? URL {
                                    // Do something with the URL
                                    self.shareURL = shareURL
                                }
                            }
                        }
                        else if itemProvider.hasItemConformingToTypeIdentifier("public.image") {
                            itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil) { (image, error) in
                                if let shareImage = image as? UIImage {
                                    // Do something with the image
                                    self.image = Image(uiImage: shareImage)
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
