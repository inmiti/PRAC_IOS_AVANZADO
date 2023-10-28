//
//  SplashViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit

class SplashViewModel: SplashViewControllerDelegate {
    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    // - MARK: - Properties -
    var viewState: ((SplashViewState) -> Void)?
    private var isToken: Bool {
        secureDataProvider.getToken()?.isEmpty == false
    }
    
    lazy var loginViewModel: LoginViewControllerDelegate = {
        LoginViewModel(apiProvider: apiProvider,
                       secureDataProvider: secureDataProvider)
    }()
    
    lazy var heroesViewModel: HeroesViewControllerDelegate = {
        HeroesViewModel(
            apiProvider: apiProvider,
            secureDataProvider: secureDataProvider)
    }()
    
    // MARK: - Initializers - 
    init(apiProvider: ApiProviderProtocol,
        secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    // MARK: - Functions -
    func onViewAppear() {
        viewState?(.loading(true))
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.isToken ? self.viewState?(.navigateToHeroes) : self.viewState?(.navigateToLogin)
        }
    }
}
