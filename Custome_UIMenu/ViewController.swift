//
//  ViewController.swift
//  Custome_UIMenu
//
//  Created by Akshaya Gunnepalli on 07/05/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var menuBtn : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func showMenuAction(_ sender: UIButton) {
        PopoverContentVC.presentViewController(on: self, sender: menuBtn, popoverItems: [PopoverItem(title: "Edit",image: UIImage(systemName: "pencil")), PopoverItem(title: "Search",image: UIImage(systemName: "magnifyingglass")), PopoverItem(title: "View Once",image: UIImage(systemName: "eye"))])
    }

}

