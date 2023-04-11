//
//  ShareViewController.swift
//  sharetempo
//
//  Created by VegaPunk on 09/04/2023.
//

import UIKit

class ShareViewController: UIViewController {
    // loadView: "If you create your views manually, you must override this method and use it to create your views."
    override func loadView() {
        super.loadView()
        self.setupView1()
    }
    
    // viewDidLoad: "This method is called after the view controller has loaded its associated views into memory. This method is called regardless of whether the views were stored in a nib file or created programmatically in the loadView method."
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(getContextUrl())
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
        textField.placeholder = "Test"
        return textField
    }()
    
    private func setupView1() {
        self.view.backgroundColor = .white
        self.setupNavBar()
        self.view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
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
