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
    
    override func loadView() {
        super.loadView()
        self.setupView1()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "My app"
        
        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)
        
        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }
    
    @objc private func cancelAction () {
        let error = NSError(domain: "com.vegapunk.tempo.extension", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }
    
    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    private func setupView1() {
        self.view.backgroundColor = .init(red: 0.0, green: 0.2, blue: 0.0, alpha: 1)
        
        self.setupNavBar()
        
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "placeholder"
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
        let speedLabel = UILabel(frame: CGRect(x: 0, y: 200, width: 300, height: 521))
        speedLabel.text = "url ?"
        speedLabel.textColor = .white
        speedLabel.lineBreakMode = .byWordWrapping
        speedLabel.numberOfLines = 0
        speedLabel.textAlignment = .left
        self.view.addSubview(speedLabel)
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProvider = item.attachments?.first as? NSItemProvider,
           itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
                if let shareURL = url as? URL {
                    // do what you want to do with shareURL
                    speedLabel.text = shareURL.description
                }
            }
        }
    }
}
