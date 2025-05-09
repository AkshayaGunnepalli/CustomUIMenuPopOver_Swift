//
//  PopOverUI.swift
//  Custome_UIMenu
//
//  Created by Akshaya Gunnepalli on 07/05/25.
//

import Foundation
import UIKit

// MARK: - PopoverItem Model
struct PopoverItem {
    var title: String
    var image: UIImage?
    var action: ((PopoverItem) -> Void)?
}

// MARK: - PopoverContentVC
class PopoverContentVC: UIViewController {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let containerView: UIView = .init()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private let stackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0.5
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .separator
        return stackView
    }()
    
    private var _popoverItems: [PopoverItem] = []
    var popoverItems: [PopoverItem] { _popoverItems }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private var selectedButton: UIButton?
    
    // MARK: - Configuring Popover Content
    func configure(with popoverItems: [PopoverItem]) {
        self._popoverItems = popoverItems
        
        for popoverItem in popoverItems {
            // This UI is Dynamic; you can configure your own UI here
            let popoverMenuButton: UIButton = UIButton()
            popoverMenuButton.setTitle(popoverItem.title, for: .normal)
            popoverMenuButton.setTitleColor(.black, for: .normal)
            popoverMenuButton.setTitleColor(.black, for: .highlighted)
            popoverMenuButton.setImage(popoverItem.image?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
            popoverMenuButton.contentHorizontalAlignment = .leading
            
            var config = UIButton.Configuration.plain()
            config.imagePadding = 10
            config.imagePlacement = .trailing
            config.attributedTitle = AttributedString(popoverItem.title, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor : UIColor.black]))
            popoverMenuButton.configuration = config
            popoverMenuButton.titleLabel?.numberOfLines = 0
            
            let buttonAction: UIAction = .init { _ in
                self.dismiss(animated: true) {
                    popoverItem.action?(popoverItem)
                }
            }
            popoverMenuButton.addAction(buttonAction, for: .touchUpInside)
            popoverMenuButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            popoverMenuButton.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
            popoverMenuButton.backgroundColor = .white
            stackView.addArrangedSubview(popoverMenuButton)
        }
    }
    
    // MARK: - Button Actions
    @objc private func buttonTouchDown(_ sender: UIButton) {
        sender.backgroundColor = .lightGray // Highlight background color
    }

    @objc private func buttonTouchUp(_ sender: UIButton) {
        sender.backgroundColor = .white // Default background color
    }
    
    // MARK: - Presenting Popover
    static func presentViewController(on parentVC: UIViewController, sender: UIView, popoverItems: [PopoverItem]) {
        guard !popoverItems.isEmpty else { return }
        
        let popoverContentController = PopoverContentVC()
        popoverContentController.configure(with: popoverItems)
        popoverContentController.view.backgroundColor = .white
        
        // Calculate height for the popover dynamically based on the items
        var height: CGFloat = 0
        for item in popoverItems {
            height += self.heightForLabel(text: item.title)
        }
        height += CGFloat((22 * popoverItems.count) + 20)
        
        popoverContentController.preferredContentSize = CGSize(width: 200, height: height)
        popoverContentController.modalPresentationStyle = .popover
        
        if let presentationController = popoverContentController.presentationController {
            presentationController.delegate = AppDelegate.shared
        }
        
        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverPresentationController.sourceView = sender
            popoverPresentationController.permittedArrowDirections = []
            popoverPresentationController.sourceRect = sender.frame
        }
        
        DispatchQueue.main.async {
            parentVC.present(popoverContentController, animated: true)
        }
    }
    
    // MARK: - Utility Method to Calculate Height for Text
    static func heightForLabel(text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 18) // Use the appropriate font size
        let maxSize = CGSize(width: 230, height: CGFloat.greatestFiniteMagnitude)
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        return textHeight
    }
}

