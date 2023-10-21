//
//  HeroesViewController.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit

protocol HeroesViewControllerDelegate {
    
}

class HeroesViewController: UIViewController {
    
    var viewModel: HeroesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
