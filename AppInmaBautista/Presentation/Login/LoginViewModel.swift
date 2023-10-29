//
//  LoginViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import Foundation

class LoginViewModel: LoginViewControllerDelegate {
    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    // MARK: - Properties -
    var viewState: ((LoginViewState) -> Void)?
    var heroesViewModel: HeroesViewControllerDelegate {
        HeroesViewModel(apiProvider: apiProvider,
                        secureDataProvider: secureDataProvider
        )
    }
    
    // MARK: - Initializers -
    init(apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    // MARK: - Public functions -
    func loginButtonPressed(email: String?, password: String?) {
        DispatchQueue.global().async {
            guard self.isvalid(email: email) else {
                self.viewState?(.errorEmail(error: "Introduzca un email válido"))
                return
            }
            guard self.isvalid(password: password) else {
                self.viewState?(.errorPassword(error: "Introduzca un password válido"))
                return
            }
            
            self.doLoggin(email: email, password: password)
        }
    }
    
    // MARK: - Private functions -
    private func isvalid(email:String?) -> Bool {
        email?.isEmpty == false && (email?.contains("@") ?? false)
    }

    private func isvalid(password:String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0 ) >= 4
    }
    
    private func doLoggin(email: String?, password: String?) {
        apiProvider.login(email: email ?? "", password: password ?? "") { [weak self] result in
            switch result {
                case .success(let token):
                    self?.secureDataProvider.saveToken(token: token)
                    self?.viewState?(.navigateToHeroes)
                case .failure(let error):
                    print("Error: \(error)")
            }
        }
    }
}
