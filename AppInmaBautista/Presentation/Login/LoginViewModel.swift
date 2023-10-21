//
//  LoginViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import Foundation

class LoginViewModel: LoginViewControllerDelegate {
    // MARK: - Properties -
    var viewState: ((LoginViewState) -> Void)?
    
    // MARK: - Dependencies -
    let apiProvider: ApiProviderProtocol
    let secureDataProvider: SecureDataProviderProtocol
    
    init(apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    // MARK: - Public functions -
    func loginButtonPressed(email: String, password: String) {
        guard isvalid(email: email) else {
            viewState?(.errorEmail(error: "Introduzca un email válido"))
            return
        }
        guard isvalid(password: password) else {
            viewState?(.errorPassword(error: "Introduzca un password válido"))
            return
        }
        apiProvider.login(email: email, password: password) { [weak self] result in
            switch result {
                case .success(let token):
                    self?.secureDataProvider.saveToken(token: token)
                    self?.viewState?(.navigateToHeroes)
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    
    // MARK: - Private functions -
    private func isvalid(email:String?) -> Bool {
        email?.isEmpty == false && (email?.contains("@") ?? false)
    }

    private func isvalid(password:String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0 ) >= 4
    }
  
}
