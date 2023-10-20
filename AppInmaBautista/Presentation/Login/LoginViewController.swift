//
//  LoginViewController.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit

protocol LoginViewControllerDelegate {
    func loginButtonPressed(email: String, password: String)
    
}
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorPasswordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ocultar el botón de retroceso en la barra de navegación
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    @IBAction func loginButton(_ sender: Any) {
        func loginButtonPressed(email: String, password: String) {
            emailTextField.text = email
            passwordTextField.text = password
        }
    }
    
    
}
