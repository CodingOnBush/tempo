//
//  ShareViewController.swift
//  sharetempo
//
//  Created by VegaPunk on 09/04/2023.
//

import UIKit

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
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }
    
    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.text = "some value"
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private func setupView1() {
        self.view.backgroundColor = .darkGray
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
}
