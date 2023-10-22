//
//  LoginViewController.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit

// MARK: - Protocol -
protocol LoginViewControllerDelegate {
    func loginButtonPressed(email: String?, password: String?)
    var viewState: ((LoginViewState) -> Void)? { get set }
    var heroesViewModel: HeroesViewControllerDelegate { get }
}

// MARK: - View State -
enum LoginViewState {
    case errorEmail(error: String)
    case errorPassword(error: String)
    case navigateToHeroes
}
class LoginViewController: UIViewController {
    // MARK: - IBOutlets -
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorPasswordLabel: UILabel!

    // MARK: - Properties -
    var viewModel: LoginViewControllerDelegate?
    
    // MARK: - IBActions -
    @IBAction func loginButton(_ sender: Any) {
        viewModel?.loginButtonPressed(
            email: emailTextField.text,
            password: passwordTextField.text)
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ocultar el botón de retroceso en la barra de navegación
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "LOGIN_TO_HEROES",
              let heroesViewController = segue.destination as? HeroesViewController else {return}
        heroesViewController.viewModel = viewModel?.heroesViewModel
    }
    // MARK: - Public funcions -
    func setObserver() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .errorEmail(let error):
                        self?.errorEmailLabel.text = error
                    case .errorPassword(let error):
                        self?.errorPasswordLabel.text = error
                    case .navigateToHeroes:
                        self?.performSegue(withIdentifier: "LOGIN_TO_HEROES", sender: nil)
                }
            }
        }
    }
}
