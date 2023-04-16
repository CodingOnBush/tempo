//
//  ShareViewController.swift
//  sharetempo
//
//  Created by VegaPunk on 09/04/2023.
//

import UIKit
import CoreData
import MobileCoreServices

class ShareViewController: UIViewController {
    
    // loadView: "If you create your views manually, you must override this method and use it to create your views."
    override func loadView() {
        super.loadView()
        
        self.setupView1()
    }
    
    // viewDidLoad: "This method is called after the view controller has loaded its associated views into memory. This method is called regardless of whether the views were stored in a nib file or created programmatically in the loadView method."
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let myCoreData = CoreData.shared
        //
        //        myCoreData.getStoredDataFromCoreData()
        //        print(URL.storeURL(for: "TEST1", databaseName: "tempo"))
        //        myCoreData.saveContext()
        
        //        print(getContextUrl())
        //        let stringURL = getContextUrl().description
        //        self.textField.placeholder = stringURL
        //        let newItem = Item(context: viewContext)
        //        newItem.timestamp = getContextUrl().description
        //
        //        do {
        //            try viewContext.save()
        //        } catch {
        //            // Replace this implementation with code to handle the error appropriately.
        //            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //            let nsError = error as NSError
        //            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        //        }
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "My app"
        
        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)
        
        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }
    
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }
    
    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = getContextUrl().description
        return textField
    }()
    
    private func setupView1() {
        self.view.backgroundColor = .init(red: 0.0, green: 0.2, blue: 0.0, alpha: 1)
        
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "placeholder"
        
        self.setupNavBar()
        
        self.view.addSubview(textField)
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func buttonAction(sender: UIButton!) {
        //        self.view.backgroundColor = .red
        let speedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        speedLabel.text = "url ?"
        speedLabel.textColor = .white
        speedLabel.textAlignment = .center
        self.view.addSubview(speedLabel)
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProvider = item.attachments?.first as? NSItemProvider,
           itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                if let shareURL = url as? URL {
                    // do what you want to do with shareURL
                    speedLabel.text = shareURL.description
                    
                }
//                self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
            }
        }
        
        
    }
    
    private func setupView2() {
        let viewFrame = CGRect(x: 0, y: 0, width: 150, height: 300)
        self.view = UIView(frame: viewFrame)
        self.view.backgroundColor = UIColor.clear
        
        let width: CGFloat = UIScreen.main.bounds.size.width
        let height: CGFloat = UIScreen.main.bounds.size.height
        let newView = UIView(frame: CGRect(x: (width * 0.10), y: (height * 0.10), width: (width * 0.75), height: (height / 2)))
        newView.backgroundColor = UIColor.yellow
        self.view.addSubview(newView)
    }
    
    func getContextUrl() -> URL {
        var contextUrl = URL(string: "")
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProvider = item.attachments?.first as? NSItemProvider,
           itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                if let shareURL = url as? URL {
                    // do what you want to do with shareURL
                    //                    stringUrl = try String(contentsOf: shareURL)
                    contextUrl = shareURL
                }
                self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
            }
        }
        
        return contextUrl!
    }
    
    
}
