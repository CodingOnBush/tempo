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

    var body: some View {
        VStack {
            Text("Share Extension URL:")
            Text(shareURL?.absoluteString ?? "No URL found")
            Text("Error : \(error)")
            Button {
//                if let inputItem = myNSExtensionContext?.inputItems.first as? NSExtensionItem,
//                   let itemProvider = inputItem.attachments?.first as? NSItemProvider {
//                       itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
//                           if let shareURL = url as? URL {
//                               // Do something with shareURL
//                               self.shareURL = shareURL
//                           }
//                       }
//                }
                
                

            } label: {
                Text("click me")
            }

        }
        .onAppear {
            if let inputItem = myNSExtensionContext?.inputItems.first as? NSExtensionItem,
               let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                   itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                       if let shareURL = url as? URL {
                           // Do something with shareURL
                           self.shareURL = shareURL
                       }
                   }
            }
        }
    }
}
