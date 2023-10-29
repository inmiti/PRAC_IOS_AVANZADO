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
    case loading(_ isLoading: Bool)
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
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - Delegate -
    var viewModel: LoginViewControllerDelegate?
    
    // MARK: - Field Type -
    private enum FieldType: Int {
        case email = 0
        case password
    }
    
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
    
    // MARK: - Private funcions -
    private func initViews() {
        emailTextField.delegate = self
        emailTextField.tag = FieldType.email.rawValue
        passwordTextField.delegate = self
        passwordTextField.tag = FieldType.password.rawValue

        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard)
            )
        )
    }
    
    @objc func dismissKeyboard() {
        // Ocultar el teclado al pulsar en cualquier punto de la vista
        view.endEditing(true)
    }
    
    private func setObserver() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading
                    case .errorEmail(let error):
                        self?.errorEmailLabel.text = error
                        self?.errorEmailLabel.isHidden = (error == nil || error.isEmpty == true)
                    case .errorPassword(let error):
                        self?.errorPasswordLabel.text = error
                        self?.errorPasswordLabel.isHidden = (error == nil || error.isEmpty == true)
                    case .navigateToHeroes:
                        self?.performSegue(withIdentifier: "LOGIN_TO_HEROES", sender: nil)
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch FieldType(rawValue: textField.tag) {
            case .email:
                errorEmailLabel.isHidden = true
            case .password:
                errorPasswordLabel.isHidden = true
            default: break
        }
    }
}
