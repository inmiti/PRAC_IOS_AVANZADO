//
//  ViewController.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit

protocol SplashViewControllerDelegate {
    var viewState: ((SplashViewState) -> Void)? { get set}
    
    func onViewAppear()
}

enum SplashViewState {
    case loading(_ isLoading: Bool)
    case navigateToLogin
//    case navigateToHeroes
}

class SplashViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: SplashViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setObserver()
        viewModel?.onViewAppear()
//        performSegue(withIdentifier: "SPLASH_TO_LOGIN", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    private func setObserver() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.activityIndicator.isHidden = !isLoading
                    case .navigateToLogin:
                        self?.performSegue(withIdentifier: "SPLASH_TO_LOGIN", sender: nil)
    //                  TODO: case .navigateToHeroes: INCLUIR
    //
                }
            }
        }
    }
}

