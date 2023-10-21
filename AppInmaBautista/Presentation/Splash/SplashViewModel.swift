//
//  SplashViewModel.swift
//  AppInmaBautista
//
//  Created by ibautista on 20/10/23.
//

import UIKit

class SplashViewModel: SplashViewControllerDelegate {
    // - MARK: - Properties -
    var viewState: ((SplashViewState) -> Void)?
    
    private var isToken: Bool {
        (secureDataProvider.getToken()?.isEmpty == false) || ((secureDataProvider.getToken() != nil) == true)
    }
    
    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let secureDataProvider: SecureDataProviderProtocol
    
    init(apiProvider: ApiProviderProtocol,
         secureDataProvider: SecureDataProviderProtocol) {
        self.apiProvider = apiProvider
        self.secureDataProvider = secureDataProvider
    }
    
    func onViewAppear() {
        viewState?(.loading(true))
        
//        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
//            self.viewState?(.navigateToLogin)
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.isToken ? self.viewState?(.navigateToHeroes) : self.viewState?(.navigateToLogin)
        }
    }
}
