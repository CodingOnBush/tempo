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
    @State private var error: String = "no error"
    var myNSExtensionContext: NSExtensionContext?
    @State var image: Image?
    
    var body: some View {
        VStack {
            Text("Share Extension URL:")
            Text(shareURL?.absoluteString ?? "No URL found")
            Text("Error : \(error)")
            image?
                .resizable()
                .scaledToFit()
            
            Button {
                if let inputItem = myNSExtensionContext?.inputItems.first as? NSExtensionItem,
                   let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                    itemProvider.loadItem(forTypeIdentifier: "public.image", options: nil, completionHandler: { (image, error) in
                        if let uiImage = image as? UIImage {
                            self.image = Image(uiImage: uiImage)
                        }
                    })
                }
            } label: {
                Text("get image")
            }
            
            Button {
                if let inputItem = myNSExtensionContext?.inputItems.first as? NSExtensionItem,
                   let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                    
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                        if let shareURL = url as? URL {
                            // Do something with shareURL
                            self.shareURL = shareURL
                        }
                    }
                }
            } label: {
                Text("get url")
            }
            
            Button {
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

            } label: {
                Text("parse")
            }
            
            
        }
    }
}
