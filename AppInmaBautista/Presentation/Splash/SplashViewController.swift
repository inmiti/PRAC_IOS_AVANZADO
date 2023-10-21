//
//  ViewController.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit

// MARK: - Protocol -
protocol SplashViewControllerDelegate {
    var viewState: ((SplashViewState) -> Void)? { get set}
    
    func onViewAppear()
}
// MARK: - View State -
enum SplashViewState {
    case loading(_ isLoading: Bool)
    case navigateToLogin
    case navigateToHeroes
}

class SplashViewController: UIViewController {
    // MARK: - Outlets -
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Properties -
    var viewModel: SplashViewControllerDelegate?
    // MARK: - Lyfecicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setObserver()
        viewModel?.onViewAppear()
    }
    
    // MARK: - Private function -
    private func setObserver() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.activityIndicator.isHidden = !isLoading
                    case .navigateToLogin:
                        self?.performSegue(withIdentifier: "SPLASH_TO_LOGIN", sender: nil)
                    case .navigateToHeroes:
                        self?.performSegue(withIdentifier: "SPLASH_TO_HEROES", sender: nil)
                }
            }
        }
    }
}

