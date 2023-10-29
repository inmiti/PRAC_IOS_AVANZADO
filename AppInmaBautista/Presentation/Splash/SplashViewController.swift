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
    var loginViewModel: LoginViewControllerDelegate { get }
    var heroesViewModel: HeroesViewControllerDelegate { get }
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
    
    // MARK: - Delegate -
    var viewModel: SplashViewControllerDelegate?
    
    // MARK: - Lyfecicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setObserver()
        viewModel?.onViewAppear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "SPLASH_TO_LOGIN":
                guard let loginViewController = segue.destination as? LoginViewController else { return }
                loginViewController.viewModel = viewModel?.loginViewModel
            case "SPLASH_TO_HEROES":
                guard let heroesViewController = segue.destination as? HeroesViewController else { return }
                heroesViewController.viewModel = viewModel?.heroesViewModel
            default:
                break
        }
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

