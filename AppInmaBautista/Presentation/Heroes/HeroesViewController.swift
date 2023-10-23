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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ocultar el botón de retroceso en la barra de navegación
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}
